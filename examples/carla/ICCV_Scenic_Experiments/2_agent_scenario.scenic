param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on laneSection, facing Range(-10, 10) deg relative to roadDirection,
		with viewAngle 135 deg,
		with visibleDistance 30
car = Pedestrian on visible lane, facing toward ego

# spot = OrientedPoint on lane
# ego = Car behind spot by Range(3,5),
# 		facing Range(-10,10) deg relative to roadDirection
# Car right of spot by Range(1,2),
# 		facing toward ego

require (distance to intersectionRegion) > 30