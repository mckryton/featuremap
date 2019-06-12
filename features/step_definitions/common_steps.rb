Before do
  @log = Logger.new(STDOUT)
  @log.datetime_format = "%H:%M:%S"
  if ENV['LOG_LEVEL'] == 'debug'
    @log.level = Logger::DEBUG
  elsif ENV['LOG_LEVEL'] == 'info'
    @log.level = Logger::INFO
  else
    # default log level
    @log.level = Logger::ERROR
  end
  @featuremap_file = nil
  delete_path("test_data")
  @path_to_results = "test_data/out"
  @path_to_testdata = "test_data/in"
end

Given("a feature dir {string}") do |feature_dir|
  @feature_dir = feature_dir
  create_path("#{@path_to_testdata}/#{@feature_dir}")
end

When("the mapper is called") do
  create_path(@path_to_results)
  @featuremap_file = "#{@path_to_results}/featuremap.mm"
  @mapper = Featuremap.new("#{@path_to_testdata}/#{@feature_dir}", @featuremap_file)
  @mapper.create_featuremap(@featuremap_file)
end

When("the user runs featuremap") do
  @log.debug "run script: bin/featuremap #{@path_to_testdata}/#{@feature_dir} #{@featuremap_file}"
  if @featuremap_file
    @stdout, @stderr, @exit_status = Open3.capture3("bin/featuremap", "#{@path_to_testdata}/#{@feature_dir}", @featuremap_file)
  else
    @stdout, @stderr, @exit_status = Open3.capture3("bin/featuremap", "#{@path_to_testdata}/#{@feature_dir}")
  end
end

Then("a mindmap file without any validation error is created") do
  #validate generated mm file with freemind.xsd
  #validate_mm returns array containing validation errors
  expect(validate_mm(@featuremap_file).count).to eq(0)
  @mindmap = Nokogiri::XML(File.read(@featuremap_file))
end
