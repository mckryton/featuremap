Given("a feature dir with a feature containing {int} scenarios") do |nr_of_scenarios|
  @path_to_testdata = "#{@path_to_testdata}/scenarios_basic"
  create_path(@path_to_testdata)
  scenarios = []
  for scenario_index in 1..nr_of_scenarios
    scenarios.unshift(["scenario nr #{scenario_index}", "Scenario"])
  end
  create_feature(@path_to_testdata, "dummy feature with scenarios.feature", scenarios)
end

Given("a feature dir with a feature containing an outline scenario") do
  @path_to_testdata = "#{@path_to_testdata}/scenarios_outline"
  create_path(@path_to_testdata)
  scenarios = [['sample outline', 'Scenario Outline']]
  create_feature(@path_to_testdata, "dummy feature with scenarios.feature", scenarios)
end

Then("the mindmap contains a feature node") do
  expect(@mindmap.xpath("/map/node/node[starts-with(@ID,'feature_')]").count).to eq(1)
end

Then("the feature node contains {int} scenario subnodes") do |nr_of_subnodes|
  expect(@mindmap.xpath("/map/node/node[starts-with(@ID,'feature_')]/node[starts-with(@ID,'scenario_')]").count).to eq(nr_of_subnodes)
end

Then("the feature node contains a scenario subnode") do
  expect(@mindmap.xpath("/map/node/node[starts-with(@ID,'feature_')]/node[starts-with(@ID,'scenario_')]").count).to eq(1)
end

Then("the scenario subnode is marked with an list icon") do
  expect(@mindmap.xpath("//node[starts-with(@ID,'scenario_')]/icon[@BUILTIN = 'list']").count).to eq(1)
end
