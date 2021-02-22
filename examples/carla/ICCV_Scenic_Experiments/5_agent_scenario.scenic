param map = localPath('../../../tests/formats/opendrive/maps/CARLA/Town05.xodr')  # or other CARLA map that definitely works
param carla_map = 'Town05'
model scenic.simulators.carla.model #located in scenic/simulators/carla/model.scenic

ego = Car on lane, facing Range(-10, 10) deg relative to roadDirection
car1 = Car ahead of ego by Range(3,5)
car2 = Car behind ego by Range(4, 10)
Car left of ego by Range(2,4)
Truck right of car2 by Range(2,4)

# require Pedestrian on roadRegion