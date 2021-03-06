model scenic.simulators.carla.model

offset = Uniform(-1,1) * Range(90, 180) deg

ego = Car on road,
	facing offset relative to roadDirection

otherCar = Car on road
require (distance to otherCar) < 10

 