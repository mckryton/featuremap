Before do
  @path_to_results = "test_data/out"
  @path_to_testdata = "test_data/in"
end

Given("a feature dir {string}") do |string|
  @path_to_testdata = "#{@path_to_testdata}/#{string}"
end

Given("it contains at least one subdir") do
  create_path("#{@path_to_testdata}/subdir")
end

Given("it contains a feature file") do
  create_feature(@path_to_testdata, "dummy.feature")
end

Given("the subdir contains a feature file") do
  create_feature("#{@path_to_testdata}/subdir", "subdir.feature")
end

Given("the feature dir contains subdirs with a different amount of features") do |table|
  @subdir_setup = table.hashes
  table.hashes.each do |table_row|
    subdir_path = "#{@path_to_testdata}/#{table_row["subdirs"]}"
    create_path(subdir_path)
    for feature_count in 1..table_row["nr_of_features"].to_i
      create_feature(subdir_path, "dummy_#{feature_count}.feature")
    end
  end
end

When("the mapper is called") do
  @mapper = Mindmap.new(@path_to_testdata)
  create_path(@path_to_results)
  @featuremap_file = "#{@path_to_results}/featuremap.mm"
  @mapper.create_featuremap(@featuremap_file)
end

Then("a mindmap file without any validation error is created") do
  #validate generated mm file with freemind.xsd
  #validate_mm returns array containing validation errors
  expect(validate_mm(@featuremap_file).count).to eq(0)
  @mindmap = Nokogiri::XML(File.read(@featuremap_file))
end

Then("the mindmap contains a node with the feature name") do
  expect(@mapper.nodes["root"]["nodes"][0]["text"]).to match("dummy feature for testing")
  expect(@mindmap.xpath("//map/node/node/@TEXT").first.to_s).to match("dummy feature for testing")
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

Then("the mindmap shows nodes for every subdir") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("the node of every subdir contains the corresponding number of feature nodes") do
  pending # Write code here that turns the phrase above into concrete actions
end
