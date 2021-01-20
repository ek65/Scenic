""" Scenario Description: 
Cut-in scenario
Ego is placed on a lane which has a lane to its right
The cut-in car is on the right lane heading 15 to 30 deg towards ego's lane.
"""

model scenic.domains.driving.model

lanesWithRightLane = filter(lambda i: i._laneToRight, network.laneSections)
egoLane = Uniform(*lanesWithRightLane)

ego = Car on egoLane
cutInCar = Car on egoLane._laneToRight,
			facing -1* Range(15, 30) deg relative to roadDirection