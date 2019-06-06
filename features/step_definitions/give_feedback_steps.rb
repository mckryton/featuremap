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

Then("featuremap exits with {int}") do |exit_status|
  expect($CHILD_STATUS.exitstatus).to eq(exit_status)
end

Then("featuremap shows the message {string}") do |err_msg|
  expect(@script_output.sub("#{@path_to_testdata}/", "")).to match(err_msg)
end
