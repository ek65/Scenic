""" Scenario Description:
On a two lane road, with each lane facing opposite traffic direction,
there is a car ahead of ego by 20 to 40 meters.
On the opposite lane, there are two cars in a line, where
one car is ahead of other by 20 to 40 meters
"""

model scenic.domains.driving.model

# parse out roads with two lanes, with opposite traffic directions
two_lane_roads = filter(lambda i: len(i.lanes)==2 and len(i.laneGroups)==2, network.roads)
select_road = Uniform(*two_lane_roads)
lane = Uniform(*select_road.laneGroups)

ego = Car on lane
Car ahead of ego by Range(20,40)

oppositeCar = Car on visible lane._opposite
Car ahead of oppositeCar by Range(20,40)

