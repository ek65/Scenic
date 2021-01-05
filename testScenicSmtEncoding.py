import scenic
import os
from scenic.core.distributions import *
from scenic.core.vectors import Vector
from scenic.core.regions import SectorRegion
import math
import subprocess

ego_visibleDistance = 100
ego_viewAngle = 135 #deg
ego_labelled_position = Vector(0, 0)
ego_labelled_heading = 0 #deg
egoVisibleRegion = SectorRegion(ego_labelled_position, ego_visibleDistance, \
                                math.radians(ego_labelled_heading), math.radians(ego_viewAngle))

def test_pointInOptions_True():
	scenic_script = "./examples/carla/test1.scenic"
	scenario = scenic.scenarioFromFile(scenic_script)
	ego = scenario.egoObject

	smt_file_path = './test_smt_encoding.smt2'
	open(smt_file_path, 'w').close()
	writeSMTtoFile(smt_file_path, '(set-logic QF_NRA)')

	cached_variables = {}
	cached_variables['variables'] = []
	vec = scenario.egoObject.position.sample()
	cached_variables['current_obj_pos'] = (vec.x, vec.y)
	cached_variables['egoVisibleRegion'] = egoVisibleRegion.polygon
	ego_pos_smt_var = ego.position.encodeToSMT(smt_file_path, cached_variables, debug = False)

	(x_cond, y_cond) = vector_operation_smt(ego_pos_smt_var, "equal", (str(vec.x), str(vec.y)))
	# (x_cond, y_cond) = vector_operation_smt(ego_pos_smt_var, "equal", (str(-248.12210439014729), str(60)))
	writeSMTtoFile(smt_file_path, smt_assert(None, x_cond))
	writeSMTtoFile(smt_file_path, smt_assert(None, y_cond))
	writeSMTtoFile(smt_file_path, "(check-sat)")
	writeSMTtoFile(smt_file_path, "(exit)")

	x = subprocess.call("./run_smt_encoding.sh")
	assert x == 1 # this means dreal outputs "sat"

def test_pointInOptions_False():
	scenic_script = "./examples/carla/test1.scenic"
	scenario = scenic.scenarioFromFile(scenic_script)
	ego = scenario.egoObject

	smt_file_path = './test_smt_encoding.smt2'
	open(smt_file_path, 'w').close()
	writeSMTtoFile(smt_file_path, '(set-logic QF_NRA)')

	cached_variables = {}
	cached_variables['variables'] = []
	vec = scenario.egoObject.position.sample()
	cached_variables['current_obj_pos'] = (-248.12210439014729, 60)
	cached_variables['egoVisibleRegion'] = egoVisibleRegion.polygon
	ego_pos_smt_var = ego.position.encodeToSMT(smt_file_path, cached_variables, debug = False)

	(x_cond, y_cond) = vector_operation_smt(ego_pos_smt_var, "equal", (str(-248.12210439014729), str(60)))
	writeSMTtoFile(smt_file_path, smt_assert(None, x_cond))
	writeSMTtoFile(smt_file_path, smt_assert(None, y_cond))
	writeSMTtoFile(smt_file_path, "(check-sat)")
	writeSMTtoFile(smt_file_path, "(exit)")

	x = subprocess.call("./run_smt_encoding.sh")
	assert x == 0 # this means dreal outputs "unsat"