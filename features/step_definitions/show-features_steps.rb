Given("a feature dir is empty") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_empty"
  create_path(@path_to_testdata)
end

Given("a feature dir is single") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_single"
end

Given("a feature dir is multiple") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_multiple"
end

Given("a feature dir containing a feature file") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_simple"
  create_feature(@path_to_testdata, "dummy feature.feature")
end

Given("it contains {int}") do |int|
  for file_nr in 1..int
    create_feature(@path_to_testdata, "dummy feature #{file_nr}.feature")
  end
end

Given("it contains <nr_of_files> files of <file_type>") do |table|
  @featuredir_setup = table.hashes
  table.hashes.each do |table_row|
    if table_row["file_type"] == "feature"
      for file_nr in 1..table_row["nr_of_files"].to_i
        create_feature("#{@path_to_testdata}/#{@feature_dir}", "dummy feature #{file_nr}.feature")
      end
    else
      for file_nr in 1..table_row["nr_of_files"].to_i
        create_other_file("#{@path_to_testdata}/#{@feature_dir}", "dummy no_feature #{file_nr}.#{table_row["file_type"]}")
      end
    end
  end
end

Then("the mindmap contains a root node named {string}") do |string|
  expect(@mindmap.xpath("/map/node/@TEXT").first.to_s).to match("featuremap")

end

Then("the mindmap contains {int} nodes") do |int|
  (1..int).each do
    expect(@mindmap.xpath("/map/node/node").count).to eq(int)
  end
end

Then("the mindmap contains only {int} feature nodes") do |int|
  expect(@mindmap.xpath("//node[starts-with(@ID, 'feature_')]").count).to eq(int)
end

Then("the feature node in this mindmap is using a bold font") do
  expect(@mindmap.xpath("//node[starts-with(@ID, 'feature_')]/font[@BOLD = 'true']").count).to eq(1)
end
