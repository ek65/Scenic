""" Scenario Description
Based on 2019 Carla Challenge Traffic Scenario 05.
Ego-vehicle performs a lane changing to evade a leading vehicle, which is moving too slowly.
"""

#SET MAP AND MODEL (i.e. definitions of all referenceable vehicle types, road library, etc)
param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic


laneSecsWithLeftLane = filter(lambda i: i._laneToLeft != None, network.laneSections)
laneSec = Uniform(*laneSecsWithLeftLane)

ego = Car on laneSec