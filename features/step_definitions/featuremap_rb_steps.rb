require 'mindmap'

Before do
  @path_to_testdata = "test_data/in/f1"
  @path_to_results = "test_data/out/f1"
  @mapper = Mindmap.new(@path_to_testdata)
end

Given("the feature dir contains a feature file") do
  #todo: add path test_data
  create_feature(@path_to_testdata, "dummy.feature")
end

When("the mapper is called") do
  create_path(@path_to_results)
  @featuremap_file = "#{@path_to_results}/featuremap.mm"
  @mapper.create_featuremap(@featuremap_file)
end

Then("a mindmap file is created") do
  #validate generated mm file with freemind.xsd
  #validate_mm returns array containing validation errors
  expect(validate_mm(@featuremap_file).count).to eq(0)
end

Then("the mindmap contains a node with the feature name") do
  expect(@mapper.nodes["root"]["nodes"][0]["text"]).to match("dummy feature for testing")
end
