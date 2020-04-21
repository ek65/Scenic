import carla
import math
from scenic.core.vectors import Vector
from scenic.core.geometry import normalizeAngle  # TODO: understand what normalizeAngle does


def scenicToCarlaLocation(pos, z=0.0):
	z = 0.0 if z is None else z
	return carla.Location(pos.x, pos.y, z)

def scenicToCarlaRotation(heading):
	# NOTE: Scenic in radians counterclockwise from forward vector
	yaw = 180 - math.degrees(heading)  # TODO: make sure this is correct
	#yaw = -heading * 180 / math.pi - 90  # Wilson's calculation from VerifiedAI/verifai/simulators/carla/carla_scenic_task.py
	return carla.Rotation(yaw=yaw)

def scalarToCarlaVector3D(x, y, z=0.0):
	# NOTE: carla.Vector3D used for velocity, acceleration; superclass of carla.Location
	z = 0.0 if z is None else z
	return carla.Vector3D(x, y, z)

def carlaToScenicPosition(loc):
	return Vector(loc.x, loc.y)  # TODO: make sure loc.y is correct

def carlaToScenicElevation(loc):
	return loc.z  # TODO: make sure this is correct

def carlaToScenicHeading(rot, tolerance2D=0):
	# NOTE: Scenic only defines yaw
	if abs(rot.pitch) > tolerance2D or abs(rot.roll) > tolerance2D:
		pass#return None
	return normalizeAngle(math.radians(180 - rot.yaw))  # TODO: make sure this is correct