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

Then("the mindmap contains a node with the feature name") do
  expect(@mindmap.xpath("/map/node/node/@TEXT").first.to_s).to match("dummy feature for testing")
end

Then("the mindmap contains a node with the subdir") do
  expect(@mindmap.xpath("/map/node/node/@TEXT").first.to_s).to match("subdir")
end

Then("the subdir node contains a node with the feature") do
  expect(@mindmap.xpath("/map/node/node[@TEXT='subdir']/node/@TEXT").first.to_s).to match("dummy feature for testing")
end

Then("the subdir node is marked by a folder icon") do
  expect(@mindmap.xpath("/map/node/node/icon").count).to eq(1)
end

Then("the mindmap shows nodes with a folder icon for every subdir") do
  @subdir_setup.each do |table_row|
    subdir_path = table_row["subdirs"]
    subdir_path.split("/").each do |subdir|
      expect(@mindmap.xpath("//node[@TEXT = '#{subdir}']").count).to eq(1)
      expect(@mindmap.xpath("//node[@TEXT = '#{subdir}']/icon").first.to_s).to match("<icon BUILTIN=\"folder\"/>")
    end
  end
end

Then("the node of every subdir contains the corresponding number of feature nodes") do
  @subdir_setup.each do |table_row|
    subdir_path = table_row["subdirs"]
    subdir = subdir_path.split("/").pop
    @log.debug "xpath: //node[@TEXT = '#{subdir}']/node[starts-with(@ID, 'feature_')]"
    expect(@mindmap.xpath("//node[@TEXT = '#{subdir}']/node[starts-with(@ID, 'feature_')]").count).to eq(table_row["nr_of_features"].to_i)
  end
end

Then("the minmap does not contain a folder node {string}") do |node_name|
  expect(@mindmap.xpath("//node[starts-with(@ID, 'subdir_') and @TEXT = '#{node_name}']").count).to eq(0)
end
