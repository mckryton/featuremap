# use securerandom to create unique id's
require 'securerandom'
require 'logger'
require_relative 'mindmap'


class Featuremap

  attr_reader :nodes

  def initialize(p_features_path)
    @log = Logger.new(STDOUT)
    @log.datetime_format = "%H:%M:%S"
    if ENV['LOG_LEVEL'] == 'debug'
      @log.level = Logger::DEBUG
    elsif ENV['LOG_LEVEL'] == 'info'
      @log.level = Logger::INFO
    else
      # default log level
      @log.level = Logger::WARN
    end
    @features_path = p_features_path
    @mindmap = Mindmap.new(@log)
  end

  # class entry point - create a minmap for a given path
  def create_featuremap(p_featuremap_path)
    read_features(@features_path)
    IO.write("#{p_featuremap_path}", @mindmap.to_s)
  end

  # scan feature folder for feature files and subdirs
  def read_features(p_features_path, p_parent_node = nil)
    features = Dir.entries(p_features_path)
    features.each do |feature_file|
      #ignore files starting with .
      if feature_file =~ /^[^\.]/
        #look for features in only in .feature files
        if feature_file =~ /\.feature$/
          feature = File.read("#{p_features_path}/#{feature_file}")
          feature.scan(/^\s*(Feature|Ability|Business Need):\s*(\S.*)$/) do |feature_type, feature_name|
            @mindmap.add_node(feature_name, "feature", p_parent_node)
          end
        end
        # look for subdirs
        if File.directory?("#{p_features_path}/#{feature_file}")
          subdir_node = @mindmap.add_node(feature_file, "subdir", p_parent_node)
          read_features("#{p_features_path}/#{feature_file}", subdir_node)
        end
      end
    end
    return nodes
  end

end
