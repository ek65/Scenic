""" Scenario Description:
A pedestrian is on a road or an intersection (including crosswalks), 
and the pedestrian's heading angle differs from ego's heading by 80 degrees or more
"""

model scenic.simulators.carla.model

ego = Car on road, 
		facing Range(-15,15) deg relative to roadDirection,
		with visibleDistance 50,
		with viewAngle 135 deg
ped = Pedestrian on visible drivableRoad,
		with regionContainedIn roadRegion,
		facing Range(0,360) deg
require abs(relative heading of ego from ped) > 80 deg