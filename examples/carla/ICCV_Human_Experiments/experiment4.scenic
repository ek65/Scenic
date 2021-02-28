""" Scenario Description:
On a two lane road, with each lane facing opposite traffic direction,
there is a car ahead of ego by 20 to 40 meters.
On the opposite lane, there are two cars in a line, where
one car is ahead of other by 20 to 40 meters
"""

param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr') 
param carla_map = 'Town05'
model scenic.domains.driving.model_nusc

# parse out roads with two lanes, with opposite traffic directions
ego = Car on road, facing Range(-15, 15) deg relative to roadDirection
Car ahead of ego by Range(20,40), facing Range(-15, 15) deg relative to roadDirection

oppositeCar = Car offset by (Range(-1, -10), Range(0, 100)), facing Range(-15, 15) deg relative to roadDirection
Car ahead of oppositeCar by Range(20,40), facing Range(-15, 15) deg relative to roadDirection

