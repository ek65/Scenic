param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr') 
param carla_map = 'Town05'
model scenic.domains.driving.model_nusc

offset = Uniform(-1,1) * Range(90, 180) deg

ego = Car on road,
	facing offset relative to roadDirection

otherCar = Car on road
require (distance to otherCar) < 10

 