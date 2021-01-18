param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

laneSecsWithLeftLane = filter(lambda i: i._laneToLeft != None, network.laneSections)
laneSec = Uniform(*laneSecsWithLeftLane)
ego = Car on laneSec

# ego.position = PointIn(Options(LaneSection, LaneSection, ...))