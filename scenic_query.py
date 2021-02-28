import scenic
scenic_script = "./examples/carla/ICCV_Scenic_Experiments/7_agent_scenario.scenic"
scenario = scenic.scenarioFromFile(scenic_script)
# unconditionAllAttributes(scenario)
scenic_label, _ = scenario.generateForQuery(maxIterations=4000, verbosity=3)
print(scenic_label.objects)