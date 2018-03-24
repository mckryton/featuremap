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
  @featuremap_file = "test_data/out/f1/featuremap.mm"
  @mapper.create_featuremap(@featuremap_file)
end

Then("a mindmap file is created") do
  #validate generated mm file with freemind.xsd
  expect(validate_mm(@featuremap_file).count).to eq(0)
end

Then("the mindmap contains a node with the feature name") do
  pending # Write code here that turns the phrase above into concrete actions
  #todo inspect subnode from Mindmap object
end
