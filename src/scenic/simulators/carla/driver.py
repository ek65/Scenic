import scenic
import pygame
from scenic.simulators.carla.simulator import CarlaSimulator


# CHANGEME
carla_world = 'Town01'
sc_file_path = 'test.sc'
address = '127.0.0.1'
port = 2000
render = True  # visualization mode ON/OFF

# Create the Simulator
simulator = CarlaSimulator(carla_world, address=address, port=port, render=render)

# Load Scenic scenario
scenario = scenic.scenarioFromFile(sc_file_path)

# Compute number of time steps to run simulations
timestep = 1.0 / 30
maxSteps = 20.0 / timestep

# Sample configurations from the scenario and run simulations
itr = 0
for _ in range(10):
    scene, __ = scenario.generate()
    simulation = simulator.createSimulation(scene)
    simulation.run(maxSteps)
    print('DONE')
pygame.quit()