param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on lane, facing Range(-10, 10) deg relative to roadDirection
car = Car ahead of ego by Range(5, 10),
		facing Range(-10,10) deg relative to roadDirection
truck = Pedestrian at (ego offset by Range(-3,3) @ Range(3,5))
require (angle from car to truck) < 0
require (distance from intersectionRegion) > 20