# use securerandom to create unique id's
require 'securerandom'
require 'logger'
require_relative 'mindmap'


class Featuremap

  attr_reader :nodes, :exit_status, :err_msg

  def initialize(p_features_path, p_verbose = false)
    @exit_status = 0
    @err_msg = ""
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
    if p_verbose
      @log.level = Logger::INFO
    end
    if Dir.exists?(p_features_path)
      @features_path = p_features_path
    else
      @exit_status = 66  # see https://www.freebsd.org/cgi/man.cgi?query=sysexits&sektion=3 for more info
      @err_msg = "can't find >>#{p_features_path}<< as feature dir"
    end
    @log.info("create a new featuremap")
    @mindmap = Mindmap.new(@log)
  end

  # class entry point - create a mindmap for a given path
  def create_featuremap(p_featuremap_path)
    if p_featuremap_path
      featuremap_path = p_featuremap_path
    else
      featuremap_path = Dir.pwd + "/featuremap.mm"
    end
    begin
      IO.write("#{featuremap_path}","")
    rescue Exception
      @err_msg = "can't write to #{featuremap_path}"
      @log.warn @err_msg
      @exit_status = 74
      return
    end
    read_features(@features_path)
    IO.write("#{featuremap_path}", @mindmap.to_s)
  end

  # scan feature folder for feature files and subdirs
  def read_features(p_features_path, p_parent_node = nil)
    # don't read features if some error happened before
    if @exit_status == 0
      feature_node = nil
      begin
        features = Dir.entries(p_features_path)
      rescue Exception
        @err_msg = "can't access >>#{p_features_path}<< as feature dir"
        @log.warn @err_msg
        @exit_status = 66
        return
      end
      features.each do |feature_file|
        #ignore files starting with .
        if feature_file =~ /^[^\.]/
          #look for features in only in .feature files
          if feature_file =~ /\.feature$/
            feature = File.read("#{p_features_path}/#{feature_file}")
            feature.scan(/^\s*(Feature|Ability|Business Need):\s*(\S.*)$/) do |feature_type, feature_name|
              feature_node = @mindmap.add_node(feature_name, "feature", p_parent_node)
            end
            feature.scan(/^\s*(Scenario|Scenario Outline):\s*(\S.*)$/) do |scenario_type, scenario_name|
              case scenario_type
              when "Scenario Outline" then @mindmap.add_node(scenario_name, "scenario_outline", feature_node)
                when "Scenario"  then @mindmap.add_node(scenario_name, "scenario", feature_node)
              end
            end
          end
          # look for subdirs
          if File.directory?("#{p_features_path}/#{feature_file}")
            # ignore step_definitions and support folders because those are used for code
            if feature_file != "step_definitions" && feature_file != "support"
              subdir_node = @mindmap.add_node(feature_file, "subdir", p_parent_node)
              read_features("#{p_features_path}/#{feature_file}", subdir_node)
            end
          end
        end
      end
    end
  end

end
