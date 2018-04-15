require 'securerandom'

class Mindmap

  attr_reader :nodes

  def initialize(p_features_path)
    @features_path = p_features_path
    @nodes = { "root" => {"text" => "featuremap", "nodes" => []}}
  end


  def create_featuremap(p_featuremap_path)
    @nodes["root"]["nodes"] = read_features(@features_path)
    IO.write("#{p_featuremap_path}", to_s)
  end


  def to_s
    map = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    map << "<map version=\"1.0.1\">\n"
    map << "<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->\n"
    map << "<node CREATED=\"#{Time.now.to_i}\" ID=\"ID_#{SecureRandom.uuid.gsub(/-/,'')}\" MODIFIED=\"#{Time.now.to_i}\" TEXT=\"#{@nodes['root']['text']}\">\n"
    map << nodes_to_s(nodes["root"]["nodes"])
    map << "</node>\n"
    map << "</map>\n"
  end


  def read_features(p_features_path)
    nodes = []
    features = Dir.entries(p_features_path)
    features.each do |feature_file|
      #ignore files starting with .
      if feature_file =~ /^[^\.]/
        #recognice only .feature files
        if feature_file =~ /\.feature$/
          feature = File.read("#{p_features_path}/#{feature_file}")
          feature.scan(/^\s*(Feature|Ability|Business Need):\s*(\S.*)$/) do |feature_type, feature_name|
            nodes.insert(0,create_node(feature_name, "feature"))
          end
        end
        if File.directory?("#{p_features_path}/#{feature_file}")
          nodes.insert(0,create_node(feature_file, "subdir"))
        end
      end
    end
    return nodes
  end

  # create a new node
  def create_node(p_node_text, p_node_type)
    node = {"created" => Time.now.to_i, "id" => SecureRandom.uuid.gsub(/-/,''), "modified" => Time.now.to_i, "text" => p_node_text, "type" => p_node_type}
  end

  def nodes_to_s(p_nodes)
    #TODO: verschachtelte nodes berücksichtigen
    nodes_text = ""
    p_nodes.each do |node|
      nodes_text << "<node CREATED=\"#{node["created"]}\" ID=\"ID_#{node["id"]}\" MODIFIED=\"#{node["modified"]}\" TEXT=\"#{node["text"]}\">\n"
      if node["type"] == "subdir"
        nodes_text << "<icon BUILTIN=\"folder\"/>"
      end
      nodes_text << "</node>"
    end
    return nodes_text
  end
end
