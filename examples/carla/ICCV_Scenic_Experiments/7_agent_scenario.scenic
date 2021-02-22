param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on lane, facing Range(-10, 10) deg relative to roadDirection
car1 = Car ahead of ego by Range(3,5)
car2 = Car behind ego by Range(4, 10)
car3 = Car left of ego by Range(4,6)
Cone right of car3 by Range(2,3)
Bicycle beyond car1 by Range(-1,1) @ Range(2,5),
	with regionContainedIn None 