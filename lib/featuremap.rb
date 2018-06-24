# use securerandom to create unique id's
require 'securerandom'

class Featuremap

  attr_reader :nodes

  def initialize(p_features_path)
    @features_path = p_features_path
    @nodes = { "root" => {"text" => "featuremap", "nodes" => []}}
  end

  # class entry point - create a minmap for a given path
  def create_featuremap(p_featuremap_path)
    read_features(@features_path, @nodes["root"]["nodes"])
    IO.write("#{p_featuremap_path}", to_s)
  end

  # convert mindmap object to string
  def to_s
    map = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    map << "<map version=\"1.0.1\">\n"
    map << "<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->\n"
    map << "<node CREATED=\"#{Time.now.to_i}\" ID=\"ID_#{SecureRandom.uuid.gsub(/-/,'')}\" MODIFIED=\"#{Time.now.to_i}\" TEXT=\"#{@nodes['root']['text']}\">\n"
    map << nodes_to_s(nodes["root"]["nodes"])
    map << "</node>\n"
    map << "</map>\n"
  end

  # scan feature folder for feature files and subdirs
  def read_features(p_features_path, p_target_node_nodes_attrib)
    features = Dir.entries(p_features_path)
    features.each do |feature_file|
      #ignore files starting with .
      if feature_file =~ /^[^\.]/
        #look for features in only in .feature files
        if feature_file =~ /\.feature$/
          feature = File.read("#{p_features_path}/#{feature_file}")
          feature.scan(/^\s*(Feature|Ability|Business Need):\s*(\S.*)$/) do |feature_type, feature_name|
            p_target_node_nodes_attrib.insert(0,create_node(feature_name, "feature"))
          end
        end
        # look for subdirs
        if File.directory?("#{p_features_path}/#{feature_file}")
          subdir_node = create_node(feature_file, "subdir")
          p_target_node_nodes_attrib.insert(0, subdir_node)
          read_features("#{p_features_path}/#{feature_file}", subdir_node["nodes"])
        end
      end
    end
    return nodes
  end

  # create a new node
  def create_node(p_node_text, p_node_type)
    node = {"created" => Time.now.to_i, "id" => SecureRandom.uuid.gsub(/-/,''), "modified" => Time.now.to_i, "text" => p_node_text, "type" => p_node_type, "nodes" => []}
  end

  # turn hash of nodes into mindmap xml string
  def nodes_to_s(p_nodes, p_nodes_text="")
    nodes_text = p_nodes_text
    p_nodes.each do |node|
      nodes_text << "<node CREATED=\"#{node["created"]}\" ID=\"ID_#{node["id"]}\" MODIFIED=\"#{node["modified"]}\" TEXT=\"#{node["text"]}\">\n"
      # add icons to nodes
      case node["type"]
      when "subdir"
        nodes_text << "<icon BUILTIN=\"folder\"/>"
      when "feature"
        nodes_text << "<icon BUILTIN=\"idea\"/>"
      when "scenario"
        nodes_text << "<icon BUILTIN=\"attach\"/>"
      end
      # call function recursively for sublevel nodes
      if not node["nodes"].empty?
        nodes_to_s(node["nodes"], nodes_text)
      end
      nodes_text << "</node>"
    end
    return nodes_text
  end
end
