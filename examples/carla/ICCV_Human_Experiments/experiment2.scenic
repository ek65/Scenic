""" Scenario Description:
There are two cars on an intersection, and the cars are heading an opposite direction
such that their heading angle difference is greater than 140 degrees. 
And, other cars' headings differs from the ego's by 50 to 135 degrees to the left.
The other2's heading differs from the ego's by 50 to 135 degrees to the right.
"""

param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr') 
param carla_map = 'Town05'
model scenic.domains.driving.model_nusc

ego = Car on road, facing Range(-15,15) deg relative to roadDirection
other1 = Car on intersection,
			facing Range(50,135) deg relative to ego.heading
other2 = Car on intersection,
			facing -1 * Range(50,135) deg relative to ego.heading

require abs(other1.heading relative to other2.heading) > 100 deg
require (distance to intersection) < 10