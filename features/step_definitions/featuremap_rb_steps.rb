require 'mindmap'

Before do
  @mapper = Mindmap.new
end

Given("the feature dir contains a feature file") do
  #todo: add path test_data
  create_feature("test_data/in/f1", "dummy.feature")
end

When("the mapper is called") do
  create_path("test_data/out/f1")
  @mapper.create_featuremap("test_data/out/f1/featuremap.mm")
end

Then("a mindmap file is created") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("the mindmap contains a node with the feature name") do
  pending # Write code here that turns the phrase above into concrete actions
end
