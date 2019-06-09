Given("{string} as a non existing location for the feature dir") do |feature_dir|
  @feature_dir = feature_dir
end

Given("the user rights for the feature dir don't allow access") do
  FileUtils.chmod("a=xw", "#{@path_to_testdata}/#{@feature_dir}")
end

Given("{string} as a non existing location for the mindmap") do |mindmap_file|
  @featuremap_file = mindmap_file
end

Given("{string} as a read-only location for the mindmap") do |path_to_mindmap|
  @featuremap_file = "#{path_to_mindmap}featuremap.mm"
  @path_to_mindmap = path_to_mindmap
  create_path("#{@path_to_results}/#{@path_to_mindmap}")
end

Given("the user rights for the minmaps don't have access for writing") do
  FileUtils.chmod("a=r", "#{@path_to_results}/#{@path_to_mindmap}")
end

Given("a mindmap file {string} already exists") do |mindmap_file_name|
  create_file(@path_to_results, mindmap_file_name, "")
end

Given("it contains a feature") do
  create_feature("#{@path_to_testdata}/#{@feature_dir}", "dummy feature.feature")
end

Given("{string} is used as an argument for the featuremap script") do |mindmap_file_name|
  @featuremap_file = "#{@path_to_results}/#{mindmap_file_name}"
end

Given("{int} multiple mindmap file with the name {string} distinguished only by number exist") do |duplicate_count, mindmap_file_name|
  create_file(@path_to_results, "#{mindmap_file_name}.mm", "")
  (1..duplicate_count-1).each do |file_nr|
    create_file(@path_to_results, "#{mindmap_file_name}-#{file_nr}.mm", "")
  end
end

Then("featuremap exits with {int}") do |exit_status|
  expect($CHILD_STATUS.exitstatus).to eq(exit_status)
end

Then("featuremap shows the message {string}") do |err_msg|
  @script_output = @script_output.sub("#{@path_to_testdata}/", "")
  @script_output = @script_output.sub("#{@path_to_results}/", "")
  expect(@script_output).to match(err_msg)
end

Then("a new mindmap with name {string} was created") do |mindmap_file_name|
  expect(File.exists?("#{@path_to_results}/#{mindmap_file_name}")).to be_truthy
  expect(validate_mm("#{@path_to_results}/#{mindmap_file_name}").count).to eq(0)
end
