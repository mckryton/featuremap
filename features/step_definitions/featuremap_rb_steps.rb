Before do
  @path_to_results = "test_data/out"
end

Given("the feature dir contains a feature file") do
  @path_to_testdata = "test_data/in/f1"
  create_feature(@path_to_testdata, "dummy.feature")
end

When("the mapper is called") do
  @mapper = Mindmap.new(@path_to_testdata)
  create_path(@path_to_results)
  @featuremap_file = "#{@path_to_results}/featuremap.mm"
  @mapper.create_featuremap(@featuremap_file)
end

Then("a mindmap file is created") do
  #validate generated mm file with freemind.xsd
  #validate_mm returns array containing validation errors
  expect(validate_mm(@featuremap_file).count).to eq(0)
  @mindmap = Nokogiri::XML(File.read(@featuremap_file))
end

Then("the mindmap contains a node with the feature name") do
  expect(@mapper.nodes["root"]["nodes"][0]["text"]).to match("dummy feature for testing")
  expect(@mindmap.xpath("//map/node/node/@TEXT").first.to_s).to match("dummy feature for testing")
end

Given("the feature dir contains at least one subdir") do
  @path_to_testdata = "test_data/in/f2"
  create_path("#{@path_to_testdata}/subdir")
end

Given("the subdir contains a feature file") do
  create_feature("#{@path_to_testdata}/subdir", "subdir.feature")
end

Then("the mindmap contains a node with the subdir") do
  expect(@mapper.nodes["root"]["nodes"][0]["text"]).to match("subdir")
  expect(@mindmap.xpath("//map/node/node/@TEXT").first.to_s).to match("subdir")
end

Then("the subdir node contains a node with the feature") do
  expect(@mapper.nodes["root"]["nodes"][0]["nodes"][0]["text"]).to match("dummy feature for testing")
  expect(@mindmap.xpath("//map/node/node[@TEXT='subdir']/node/@TEXT").first.to_s).to match("dummy feature for testing")
end

Then("the subdir node is marked by a folder icon") do
  expect(@mindmap.xpath("//map/node/node/icon").count).to eq(1)
end
