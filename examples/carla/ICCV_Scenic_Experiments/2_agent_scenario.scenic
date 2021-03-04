param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

# ego = Car on laneSection, facing Range(-10, 10) deg relative to roadDirection
# car = Car ahead of ego by Range(3, 5),
# 	facing Normal(-10,10) deg relative to roadDirection

spot = OrientedPoint on laneSection
# ego = Car left of spot by Range(2,3)
		# facing Range(-10,10) deg relative to roadDirection
ego = Car behind spot by Range(3,5)
		# facing toward ego

require (distance to intersectionRegion) > 20