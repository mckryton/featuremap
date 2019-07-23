module Featuremap
  class Mindmap

    def initialize(p_logger)
      @log = p_logger
      @nodes = []
      root_node = create_node("featuremap","root")
      @nodes.insert(0, root_node)
    end

    # convert mindmap object to string
    def to_s
      map = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      map << "<map version=\"1.0.1\">\n"
      map << "<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->\n"
      map << nodes_to_s(@nodes)
      map << "</map>\n"
    end

    # create a new node
    def create_node(p_node_text, p_node_type, p_node_color = nil)
      return {"color" => "#{p_node_color}", "created" => Time.now.to_i, "id" => SecureRandom.uuid.gsub(/-/,''), "modified" => Time.now.to_i, "text" => p_node_text, "type" => p_node_type, "nodes" => []}
    end

    # add a new node
    def add_node(p_node_text, p_node_type, p_parent_node = nil, p_node_color = nil)
      new_node = create_node(p_node_text, p_node_type, p_node_color)
      # add new node on top level per default
      if p_parent_node.nil?
         p_parent_node = @nodes[0]
      end
      p_parent_node["nodes"].insert(0, new_node)
      return new_node
    end

    # turn hash of nodes into mindmap xml string
    def nodes_to_s(p_nodes, p_nodes_text="")
      nodes_text = p_nodes_text
      p_nodes.each do |node|
        #set optional node attributes
        if node["color"] != nil
          color = "COLOR=\"#{node["color"]}\" "
        else
          color = ""
        end
        nodes_text << "<node #{color}CREATED=\"#{node["created"]}\" ID=\"#{node["type"]}_#{node["id"]}\" MODIFIED=\"#{node["modified"]}\" TEXT=\"#{node["text"]}\">\n"
        # add icons and fonts to nodes
        case node["type"]
        when "feature"
          nodes_text << "<font BOLD=\"true\" NAME=\"SansSerif\" SIZE=\"12\"/>"
        when "subdir"
          nodes_text << "<icon BUILTIN=\"folder\"/>\n"
        when "scenario_outline"
          nodes_text << "<icon BUILTIN=\"list\"/>\n"
        when "tag"
          nodes_text << "<icon BUILTIN=\"attach\"/>\n"
        end
        # call function recursively for sublevel nodes
        if not node["nodes"].empty?
          nodes_to_s(node["nodes"], nodes_text)
        end
        nodes_text << "</node>\n"
      end
      return nodes_text
    end

  end
end
