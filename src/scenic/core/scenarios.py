"""Scenario and scene objects."""

import random
import time

from scenic.core.distributions import Samplable, RejectionException, needsSampling, Options
from scenic.core.lazy_eval import needsLazyEvaluation
from scenic.core.external_params import ExternalSampler
from scenic.core.regions import EmptyRegion
from scenic.core.workspaces import Workspace
from scenic.core.vectors import Vector
from scenic.core.utils import areEquivalent
from scenic.core.errors import InvalidScenarioError
import scenic.syntax.veneer as veneer

class Scene:
	"""Scene()

	A scene generated from a Scenic scenario.

	Attributes:
		objects (tuple of :obj:`~scenic.core.object_types.Object`): All objects in the
		  scene. The ``ego`` object is first.
		egoObject (:obj:`~scenic.core.object_types.Object`): The ``ego`` object.
		params (dict): Dictionary mapping the name of each global parameter to its value.
		workspace (:obj:`~scenic.core.workspaces.Workspace`): Workspace for the scenario.
	"""
	def __init__(self, workspace, objects, egoObject, params,
				 alwaysReqs=(), terminationConds=(), termSimulationConds=(), monitors=(),
				 behaviorNamespaces={}, dynamicScenario=None):
		self.workspace = workspace
		self.objects = tuple(objects)
		self.egoObject = egoObject
		self.params = params
		self.alwaysRequirements = tuple(alwaysReqs)
		self.terminationConditions = tuple(terminationConds)
		self.terminateSimulationConditions = tuple(termSimulationConds)
		self.monitors = tuple(monitors)
		self.behaviorNamespaces = behaviorNamespaces
		self.dynamicScenario = dynamicScenario

	def show(self, zoom=None, block=True):
		"""Render a schematic of the scene for debugging."""
		import matplotlib.pyplot as plt
		plt.gca().set_aspect('equal')
		# display map
		self.workspace.show(plt)
		# draw objects
		for obj in self.objects:
			obj.show(self.workspace, plt, highlight=(obj is self.egoObject))
		# zoom in if requested
		if zoom != None:
			self.workspace.zoomAround(plt, self.objects, expansion=zoom)
		plt.show(block=block)

class Scenario:
	"""Scenario()

	A compiled Scenic scenario, from which scenes can be sampled.
	"""
	def __init__(self, workspace, simulator,
				 objects, egoObject,
				 params, externalParams,
				 requirements, requirementDeps,
				 monitors, behaviorNamespaces,
				 dynamicScenario):
		if workspace is None:
			workspace = Workspace()		# default empty workspace
		self.workspace = workspace
		self.simulator = simulator		# simulator for dynamic scenarios
		# make ego the first object, while otherwise preserving order
		ordered = []
		for obj in objects:
			if obj is not egoObject:
				ordered.append(obj)
		self.objects = (egoObject,) + tuple(ordered) if egoObject else tuple(ordered)
		self.egoObject = egoObject
		self.params = dict(params)
		self.externalParams = tuple(externalParams)
		self.externalSampler = ExternalSampler.forParameters(self.externalParams, self.params)
		self.monitors = tuple(monitors)
		self.behaviorNamespaces = behaviorNamespaces
		self.dynamicScenario = dynamicScenario

		staticReqs, alwaysReqs, terminationConds = [], [], []
		self.requirements = tuple(dynamicScenario._requirements)	# TODO clean up
		self.alwaysRequirements = tuple(dynamicScenario._alwaysRequirements)
		self.terminationConditions = tuple(dynamicScenario._terminationConditions)
		self.terminateSimulationConditions = tuple(dynamicScenario._terminateSimulationConditions)
		self.initialRequirements = self.requirements + self.alwaysRequirements
		assert all(req.constrainsSampling for req in self.initialRequirements)
		# dependencies must use fixed order for reproducibility
		paramDeps = tuple(p for p in self.params.values() if isinstance(p, Samplable))
		behaviorDeps = []
		for namespace in self.behaviorNamespaces.values():
			for value in namespace.values():
				if isinstance(value, Samplable):
					behaviorDeps.append(value)
		self.dependencies = self.objects + paramDeps + tuple(requirementDeps) + tuple(behaviorDeps)

		self.validate()

	def isEquivalentTo(self, other):
		if type(other) is not Scenario:
			return False
		return (areEquivalent(other.workspace, self.workspace)
			and areEquivalent(other.objects, self.objects)
			and areEquivalent(other.params, self.params)
			and areEquivalent(other.externalParams, self.externalParams)
			and areEquivalent(other.requirements, self.requirements)
			and other.externalSampler == self.externalSampler)

	def containerOfObject(self, obj):
		if hasattr(obj, 'regionContainedIn') and obj.regionContainedIn is not None:
			return obj.regionContainedIn
		else:
			return self.workspace.region

	def validate(self):
		"""Make some simple static checks for inconsistent built-in requirements.

		:meta private:
		"""
		objects = self.objects
		staticVisibility = self.egoObject and not needsSampling(self.egoObject.visibleRegion)
		staticBounds = [self.hasStaticBounds(obj) for obj in objects]
		for i in range(len(objects)):
			oi = objects[i]
			container = self.containerOfObject(oi)
			# Trivial case where container is empty
			if isinstance(container, EmptyRegion):
				raise InvalidScenarioError(f'Container region of {oi} is empty')
			# skip objects with unknown positions or bounding boxes
			if not staticBounds[i]:
				continue
			# Require object to be contained in the workspace/valid region
			if not needsSampling(container) and not container.containsObject(oi):
				raise InvalidScenarioError(f'Object at {oi.position} does not fit in container')
			# Require object to be visible from the ego object
			if staticVisibility and oi.requireVisible is True and oi is not self.egoObject:
				if not self.egoObject.canSee(oi):
					raise InvalidScenarioError(f'Object at {oi.position} is not visible from ego')
			# Require object to not intersect another object
			for j in range(i):
				oj = objects[j]
				if not staticBounds[j]:
					continue
				if oi.intersects(oj):
					raise InvalidScenarioError(f'Object at {oi.position} intersects'
											   f' object at {oj.position}')

	def hasStaticBounds(self, obj):
		if needsSampling(obj.position):
			return False
		if any(needsSampling(corner) for corner in obj.corners):
			return False
		return True

	def generate(self, maxIterations=2000, verbosity=0, feedback=None):
		"""Sample a `Scene` from this scenario.

		Args:
			maxIterations (int): Maximum number of rejection sampling iterations.
			verbosity (int): Verbosity level.
			feedback (float): Feedback to pass to external samplers doing active sampling.
				See :mod:`scenic.core.external_params`.

		Returns:
			A pair with the sampled `Scene` and the number of iterations used.

		Raises:
			`RejectionException`: if no valid sample is found in **maxIterations** iterations.
		"""
		objects = self.objects

		# choose which custom requirements will be enforced for this sample
		activeReqs = [req for req in self.initialRequirements if random.random() <= req.prob]

		# do rejection sampling until requirements are satisfied
		rejection = True
		iterations = 0
		while rejection is not None:
			if iterations > 0:	# rejected the last sample
				if verbosity >= 2:
					print(f'  Rejected sample {iterations} because of: {rejection}')
				if self.externalSampler is not None:
					feedback = self.externalSampler.rejectionFeedback
			if iterations >= maxIterations:
				raise RejectionException(f'failed to generate scenario in {iterations} iterations')
			iterations += 1
			try:
				if self.externalSampler is not None:
					self.externalSampler.sample(feedback)
				sample = Samplable.sampleAll(self.dependencies)
			except RejectionException as e:
				rejection = e
				continue
			rejection = None
			ego = sample[self.egoObject]
			# Normalize types of some built-in properties
			for obj in objects:
				sampledObj = sample[obj]
				assert not needsSampling(sampledObj)
				# position, heading
				assert isinstance(sampledObj.position, Vector)
				sampledObj.heading = float(sampledObj.heading)
				# behavior
				behavior = sampledObj.behavior
				if behavior is not None and not isinstance(behavior, veneer.Behavior):
					raise InvalidScenarioError(
						f'behavior {behavior} of Object {obj} is not a behavior')

			# Check built-in requirements
			for i in range(len(objects)):
				vi = sample[objects[i]]
				# Require object to be contained in the workspace/valid region
				container = self.containerOfObject(vi)
				if not container.containsObject(vi):
					rejection = 'object containment'
					break
				# Require object to be visible from the ego object
				if vi.requireVisible and vi is not ego and not ego.canSee(vi):
					rejection = 'object visibility'
					break
				# Require object to not intersect another object
				for j in range(i):
					vj = sample[objects[j]]
					if vi.intersects(vj):
						rejection = 'object intersection'
						break
				if rejection is not None:
					break
			if rejection is not None:
				continue
			# Check user-specified requirements
			for req in activeReqs:
				if not req.satisfiedBy(sample):
					rejection = f'user-specified requirement (line {req.line})'
					break

		# obtained a valid sample; assemble a scene from it
		sampledObjects = tuple(sample[obj] for obj in objects)
		sampledParams = {}
		for param, value in self.params.items():
			sampledValue = sample[value]
			assert not needsLazyEvaluation(sampledValue)
			sampledParams[param] = sampledValue
		sampledNamespaces = {}
		for modName, namespace in self.behaviorNamespaces.items():
			sampledNamespace = { name: sample[value] for name, value in namespace.items() }
			sampledNamespaces[modName] = (namespace, sampledNamespace, namespace.copy())
		alwaysReqs = (veneer.BoundRequirement(req, sample) for req in self.alwaysRequirements)
		terminationConds = (veneer.BoundRequirement(req, sample)
							for req in self.terminationConditions)
		termSimulationConds = (veneer.BoundRequirement(req, sample)
							   for req in self.terminateSimulationConditions)
		scene = Scene(self.workspace, sampledObjects, ego, sampledParams,
					  alwaysReqs, terminationConds, termSimulationConds, self.monitors,
					  sampledNamespaces, self.dynamicScenario)
		return scene, iterations

	def checkRequirements(self):
		sample = Samplable.sampleAll(self.dependencies)
		for req in self.initialRequirements:
			if not req.satisfiedBy(sample):
				return False
		return True

	def resetExternalSampler(self):
		"""Reset the scenario's external sampler, if any.

		If the Python random seed is reset before calling this function, this
		should cause the sequence of generated scenes to be deterministic."""
		self.externalSampler = ExternalSampler.forParameters(self.externalParams, self.params)

	def getSimulator(self):
		if self.simulator is None:
			raise RuntimeError('scenario does not specify a simulator')
		try:
			assert not veneer._globalParameters		# TODO improve hack!
			veneer._globalParameters = dict(self.params)
			return self.simulator()
		finally:
			veneer._globalParameters = {}

	# a function to traverse the expression tree
	def traverse(self, obj, depList, featureList):
	    # Input: type(depList) := set
	    depList.add(obj)
	    if (obj._dependencies is None) or (obj in featureList):
	        return depList
	    for dep in obj._dependencies:
	        if isinstance(dep._conditioned, Samplable):
	            depList = self.traverse(dep, depList, featureList)
	    return depList

	def conditionPosForDepAnalysis(self, obj, depth=0):
	    """Limitation: Technically, Options of network element is also an intermediate variable
	    However, we are optimizing here to avoid having too many objs sharing the same intermediate var
	    to prevent joint smt translation"""
	    
	    if depth==0:
	        obj._conditionTo(0.0)
	    
	    if (obj._dependencies is None):
	        return None

	    from scenic.domains.driving.roads import NetworkElement
	    if isinstance(obj._conditioned, Options) and isinstance(obj.options[0], NetworkElement):
	#         print("obj to be conditioned: ",obj._conditioned)
	        obj.conditionTo(0.0)
	        return None
	    
	    for dep in obj._dependencies:
	        if isinstance(dep._conditioned, Samplable):
	            self.conditionPosForDepAnalysis(dep, depth+1) 
	    return None

	def resetConditionedVar(self, obj):
	    obj._conditioned = obj
	    if (obj._dependencies is None):
	        return None
	    
	    for dep in obj._dependencies:
	        self.resetConditionedVar(dep)
	    return None

	def resetConditionedObj(self):
	    for obj in self.objects:
	        self.resetConditionedVar(obj.position)
	        self.resetConditionedVar(obj.heading)

	def extractObjDependencies(self, objDep):
	    # Input: type(objDep) := dictionary
	    # Output: objDep := key: obj, value: not feature dependent dependencies
	    # this non-feature dependence is to analyze for intermediate var dependence analysis
	    
	    featureList = set()
	    for obj in self.objects:
	        posDep = set()
	        headingDep = set()
	        objDep[obj] = {}

	        # TODO: need to generalize following conditions to all attributes
	        objDep[obj]['position'] = self.traverse(obj.position, posDep, featureList)
	        featureList.add(obj.position)
	        self.conditionPosForDepAnalysis(obj.position)

	        objDep[obj]['heading'] = self.traverse(obj.heading, headingDep, featureList)
	        featureList.add(obj.heading)
	        obj.heading.conditionTo(0.0)
	    return objDep

	def findObjByValue(self, dictionary, value):
	    for key in dictionary.keys():
	        if value in dictionary[key]:
	            return key
	    return None

	def analyzeDependencies(self, objDep, debug=False):
	    objects = self.objects
	    feature_list = set()
	    obj_feature_dict = {}
	    
	    count = 0
	    for obj in objects:
	        objDep[obj]['dependent_objs'] = set()
	        objDep[obj]['jointly_dependent'] = set()
	        objDep[obj]['self'] = 'obj'+str(count)
	        objDep['obj'+str(count)] = obj
	        objDep[obj]['dependent_objs_str'] = set()
	        objDep[obj]['jointly_dependent_str'] = set()
	        
	        # TODO: generalize to add any features of users interest
	        feature_list.update([obj.position, obj.heading])
	        obj_feature_dict[obj] = set([obj.position, obj.heading])
	        count+=1
	    
	    for i in range(len(objects)):
	        for j in range(len(objects)-(i+1)):
	            obj1 = objects[i]
	            obj2 = objects[j+i+1]
	            obj1_str = 'obj'+str(i)
	            obj2_str = 'obj'+str(j+i+1)
	            obj1_index = i
	            obj2_index = j+i+1
	            
	            obj1_pos = objDep[obj1]['position']
	            obj2_pos = objDep[obj2]['position']
	            
	            intersection_elem = obj1_pos.intersection(obj2_pos)
	            
	            if len(intersection_elem) >= 1:
	                # TODO: need to generalize following conditions to all attributes
	                if ((obj1.position in intersection_elem) and not (obj1.position is obj2.position)) \
	                    or ((obj1.heading in intersection_elem) and not (obj1.heading is obj2.heading)):
	                    objDep[obj2]['dependent_objs'].add(obj1)
	                    if debug:
	                        objDep[obj2]['dependent_objs_str'].add(objDep[obj1]['self'])
	                elif ((obj2.position in intersection_elem) and not (obj2.position is obj1.position))\
	                    or ((obj2.heading in intersection_elem) and not (obj2.heading is obj1.heading)):
	                    objDep[obj1]['dependent_objs'].add(obj2)
	                    if debug:
	                        objDep[obj1]['dependent_objs_str'].add(objDep[obj2]['self'])
	                elif len(feature_list.intersection(intersection_elem))==len(intersection_elem):
	                    for feature in feature_list.intersection(intersection_elem):
	                        if not (feature in obj_feature_dict[obj1]):
	                            objToAdd = self.findObjByValue(obj_feature_dict, feature)
	                            objDep[obj1]['dependent_objs'].add(objToAdd)
	                            if debug:
	                                objDep[obj1]['dependent_objs_str'].add(objDep[objToAdd]['self'])
	                        if not (feature in obj_feature_dict[obj2]):
	                            objToAdd = self.findObjByValue(obj_feature_dict, feature)
	                            objDep[obj2]['dependent_objs'].add(objToAdd)
	                            if debug:
	                                objDep[obj2]['dependent_objs_str'].add(objDep[objToAdd]['self'])
	                else:
	                    objDep[obj1]['jointly_dependent'].add(obj2)
	                    objDep[obj2]['jointly_dependent'].add(obj1)
	                    if debug:
	                        objDep[obj1]['jointly_dependent_str'].add(objDep[obj2]['self'])
	                        objDep[obj2]['jointly_dependent_str'].add(objDep[obj1]['self'])
	    return objDep
	            
	    
	def findObj(self, output_list, obj, objDep, debug = False):
	    # returns the index where the obj is located in output_list
	    index = 0
	    if debug:
	        obj = objDep[obj]['self']
	    for elem in output_list:
	        if obj in elem:
	            return index
	        index += 1
	    return None
	        
	    
	def computeObjsDependencyOrder(self, objDep, debug = False):
	    objects = self.objects
	    output = []
	    count = 0
	    for obj in objects:
	        if debug:
	            jointlyDependentObj = objDep[obj]['jointly_dependent_str']
	        else:
	            jointlyDependentObj = objDep[obj]['jointly_dependent']
	        index = self.findObj(output, obj, objDep, debug)
	        if index == None:
	            jointObjs = set()
	            output.append(jointObjs)
	        else:
	            jointObjs = output[index]
	        
	        if debug:
	            jointObjs.add(objDep[obj]['self'])
	        else:
	            jointObjs.add(obj)
	        
	        if len(jointlyDependentObj) != len(jointObjs.intersection(jointlyDependentObj)):
	            for elem in jointlyDependentObj:
	                if elem not in jointObjs:
	                    jointObjs.add(elem)
	        count += 1
	        
	    # shuffle the output to abide by the dependency relation
	    count = 0
	    for obj in objects:
	        obj_index = self.findObj(output, obj, objDep, debug)
	        if debug:
	            dependentObj = objDep[obj]['dependent_objs_str']
	            print("obj : ", objDep[obj]['self'])
	        else:
	            dependentObj = objDep[obj]['dependent_objs']
	        
	        for elem in dependentObj:
	            if debug:
	                dep_index = self.findObj(output, objDep[elem], objDep, debug)
	                print("elem: ", elem)
	                print("output: ", output)
	            else:
	                dep_index = self.findObj(output, obj, objDep, debug)
	            
	            if dep_index > obj_index:
	                insert_index = 0 if obj_index == 0 else obj_index-1
	                output.insert(insert_index, output.pop(dep_index))
	        count += 1
	    return output
