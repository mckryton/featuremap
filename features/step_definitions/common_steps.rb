Before do
  @log = Logger.new(STDOUT)
  @log.datetime_format = "%H:%M:%S"
  if ENV['LOG_LEVEL'] == 'debug'
    @log.level = Logger::DEBUG
  elsif ENV['LOG_LEVEL'] == 'info'
    @log.level = Logger::INFO
  else
    # default log level
    @log.level = Logger::INFO
  end
  @path_to_results = "test_data/out"
  @path_to_testdata = "test_data/in"
end

Given("a feature dir {string}") do |string|
  @path_to_testdata = "#{@path_to_testdata}/#{string}"
end

When("the mapper is called") do
  @mapper = Featuremap.new(@path_to_testdata)
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
