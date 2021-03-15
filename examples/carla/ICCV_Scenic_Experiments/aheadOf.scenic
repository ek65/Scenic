param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town01.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town01'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on lane,
		facing roadDirection

# point = Point ahead of ego by Range(3,4)

# lastCar = Car at point,
# 			with regionContainedIn drivableRegion

def placeCarAhead(lastCar, numCar):
	for i in range(numCar):
		lastCar = Car ahead of lastCar by Range(3,4), 
					with regionContainedIn drivableRegion

placeCarAhead(ego, 5)
require (distance from ego to intersectionRegion) > 5
