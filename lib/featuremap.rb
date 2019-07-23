# use securerandom to create unique id's
require 'securerandom'
require 'logger'
require 'cuke_modeler'
require_relative 'mindmap'

module Featuremap

  class Featuremap

    attr_reader :nodes, :exit_status, :mindmap_path, :features_path, :options

    def initialize(p_features_path, p_mindmap_path, p_options = {})
      @options = {"verbose" => false, "use_tags" => false}.merge(p_options)
      if p_mindmap_path == "STDOUT"
        @log = Logger.new(STDERR)
      else
        @log = Logger.new(STDOUT)
      end
      @log.formatter = proc do |severity, datetime, progname, msg|
        date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
        "[#{date_format}] #{severity.ljust(5,' ')}: #{msg}\n"
      end
      @log.datetime_format = "%H:%M:%S"
      if ENV['LOG_LEVEL'] == 'debug'
        @log.level = Logger::DEBUG
      elsif ENV['LOG_LEVEL'] == 'info'
        @log.level = Logger::INFO
      elsif ENV['LOG_LEVEL'] == 'warn'
        @log.level = Logger::WARN
      else
        # default log level
        @log.level = Logger::ERROR
      end
      if @options["verbose"] && @log.level != Logger::DEBUG && p_mindmap_path != "STDOUT"
        @log.level = Logger::INFO
        @log.info "set log level to verbose"
      end
      @exit_status = 0
      @mindmap_path = p_mindmap_path
      if Dir.exists?(p_features_path)
        @features_path = p_features_path
        @log.info("create a new featuremap")
        @mindmap = Mindmap.new(@log)
      else
        @exit_status = 66  # see https://www.freebsd.org/cgi/man.cgi?query=sysexits&sektion=3 for more info
        @log.error("can't find >>#{p_features_path}<< as feature dir")
        return
      end
    end

    # class entry point - create a mindmap for a given path
    def create_featuremap()
      mindmap_path = @mindmap_path
      if mindmap_path != "STDOUT"
        while File.exists?(mindmap_path)
          filename_parts = mindmap_path.split(".")
          if filename_parts[0] =~ /-\d+$/
            filename_parts = filename_parts[0].split("-")
            mindmap_path = "#{filename_parts[0]}-#{filename_parts[1].to_i + 1}.mm"
          else
            mindmap_path = "#{filename_parts[0]}-1.mm"
          end
        end
        if mindmap_path != @mindmap_path
          @log.warn("given mindmap name is already in use, created #{mindmap_path}")
        end
        begin
          IO.write("#{mindmap_path}","")
        rescue Exception
          @log.error("can't write to #{mindmap_path}")
          @exit_status = 74
          return
        end
      end
      begin
        directory_model = CukeModeler::Directory.new(@features_path)
        @log.info "start reading features from dir #{@features_path}"
        if @options["use_tags"]
          puts ">>>> use tags"
          read_features_and_tags(directory_model)
        else
          puts ">>>> use subdirs"
          read_features_and_subdirs(directory_model)
        end
      rescue Exception => e
        @log.error("can't access >>#{features_path}<< as feature dir")
        @log.debug(e.message)
        @exit_status = 66
        return
      end
      if @exit_status == 0
        if mindmap_path != "STDOUT"
          mindmap_file = File.open(mindmap_path,"w")
          mindmap_file.write(@mindmap.to_s)
          mindmap_file.close
        else
          puts @mindmap.to_s
        end
      end
    end

    # build the mindmap by attaching feature nodes to subdir nodes
    def read_features_and_subdirs(p_cm_directory, p_parent_node = nil)
      feature_node = nil
      p_cm_directory.feature_files.each do |feature_file|
        feature_node = @mindmap.add_node(feature_file.feature.name, "feature", p_parent_node)
        feature_file.feature.tests.each do |scenario|
          if scenario.keyword == "Scenario"
            @mindmap.add_node(scenario.name, "scenario", feature_node)
          elsif scenario.keyword == "Scenario Outline"
            @mindmap.add_node(scenario.name, "scenario_outline", feature_node)
          end
        end
      end
      p_cm_directory.directories.each do |sub_dir|
        if sub_dir.name != "step_definitions" and sub_dir.name != "support"
          subdir_node = @mindmap.add_node(sub_dir.name, "subdir", p_parent_node)
          @log.info("add features from #{sub_dir.path}")
          read_features_and_subdirs(sub_dir, subdir_node)
        end
      end
    end

    # build the mindmap by attaching feature nodes to tag nodes
    def read_features_and_tags(p_cm_directory, p_parent_node = nil)
      puts "start using tags"
      feature_node = nil
      tags = {}
      p_cm_directory.feature_files.each do |feature_file|
        feature_file.feature.all_tags.each do |tag|
          # add tag nodes to root if new
          if tags[tag.name] == nil
            @log.info("add tag #{tag.name}")
            tag_node = @mindmap.add_node(tag.name, "tag", p_parent_node)
            # remember tag, so that each tag node is created only once
            tags[tag.name] = tag_node
          else
            tag_node = tags[tag.name]
          end
          # add feature node to all tag nodes
          feature_node = @mindmap.add_node(feature_file.feature.name, "feature", tag_node)
          # add scenario nodes to features
          feature_file.feature.tests.each do |scenario|
            if scenario.keyword == "Scenario"
              @mindmap.add_node(scenario.name, "scenario", feature_node)
            elsif scenario.keyword == "Scenario Outline"
              @mindmap.add_node(scenario.name, "scenario_outline", feature_node)
            end
          end
        end
      end
      p_cm_directory.directories.each do |sub_dir|
        if sub_dir.name != "step_definitions" and sub_dir.name != "support"
          @log.info("add features from #{sub_dir.path}")
          read_features_and_tags(sub_dir)
        end
      end
    end

  end
end
