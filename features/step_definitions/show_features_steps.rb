Given("a feature dir feature_dir_empty") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_empty"
  create_path(@path_to_testdata)
end

Given("a feature dir feature_dir_single") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_single"
end

Given("a feature dir feature_dir_multiple") do
  @path_to_testdata = "#{@path_to_testdata}/feature_dir_multiple"
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
        create_feature(@path_to_testdata, "dummy feature #{file_nr}.feature")
      end
    else
      for file_nr in 1..table_row["nr_of_files"].to_i
        create_other_file(@path_to_testdata, "dummy no_feature #{file_nr}.#{table_row["file_type"]}")
      end
    end
  end
end

Then("the mindmap contains a root node named {string}") do |string|
  expect(@mindmap.xpath("/map/node/@TEXT").first.to_s).to match("featuremap")

end

Then("the mindmap contains {int} nodes marked by an lightbulb icon") do |int|
  for file_nr in 1..int
    expect(@mindmap.xpath("/map/node/node/icon[@BUILTIN = 'idea']/..").count).to eq(int)
  end
end

Then("the mindmap contains only {int} feature nodes") do |int|
  expect(@mindmap.xpath("//node/icon[@BUILTIN = 'idea']/..").count).to eq(int)
end
