Before do
  @log = Logger.new(STDOUT)
  @log.datetime_format = "%H:%M:%S"
  @log.level = Logger::INFO
end
