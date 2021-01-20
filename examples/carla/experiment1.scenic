""" Scenario Description:
A pedestrian is on a road or an intersection (including crosswalks), 
and the pedestrian's heading angle differs from ego's heading by 80 degrees or more
"""

param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr') 
param carla_map = 'Town05'
model scenic.domains.driving.model

ego = Car on road
ped = Pedestrian on visible Uniform(*network.intersections, *network.roads)
require abs(ego.heading relative to ped.heading) > 80 deg