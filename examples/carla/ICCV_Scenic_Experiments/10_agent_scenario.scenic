param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on lane, facing Range(-10, 10) deg relative to roadDirection,
		with viewAngle 135 deg,
		with visibleDistance 50
car1 = Car ahead of ego by Range(3,5)
ped1 = Pedestrian on visible road, 
	apparently facing Range(-10,10) deg from car1,
	with regionContainedIn None
car2 = Car behind ego by Range(4, 10)
car3 = Car left of ego by Range(4,6), facing toward car1
Cone right of car3 by Range(2,3)
Bicycle beyond car1 by Range(-1,1) @ Range(2,5),
	with regionContainedIn None 
mc = Motorcycle offset along Range(-10, 10) deg by Range(-1,1) @ Range(3,5),
	facing Range(-20,20) deg relative to roadDirection
ped2 = Pedestrian at (mc offset by Range(-2,2) @ Range(3,5)),
	with regionContainedIn None
Trash left of mc by 2

require (distance from ego to ped2) < 50