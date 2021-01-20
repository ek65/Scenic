""" Scenario Description:
Ego car is against the traffic flow direction by 90 to 180 degrees, either to left or right.

"""

model scenic.simulators.carla.model

ego = Car on road,
		facing Uniform(-1,1) * Range(90, 180) deg relative to roadDirection

otherCar = Car on road
require (distance to otherCar) < 10