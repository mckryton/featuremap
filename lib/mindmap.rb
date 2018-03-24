require 'securerandom'

class Mindmap

  def initialize
    @nodes = { "root" => {"text" => "featuremap"}}
  end

  def create_featuremap(full_path)
    IO.write("#{full_path}", to_s)
  end

  def to_s
    map = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    map << "<map version=\"1.0.1\">\n"
    map << "<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->\n"
    map << "<node CREATED=\"#{Time.now.to_i}\" ID=\"ID_#{SecureRandom.uuid.gsub(/-/,'')}\" MODIFIED=\"#{Time.now.to_i}\" TEXT=\"#{@nodes['root']['text']}\"/>\n"

    #map << getTextFromNodes(nodes["root"]["nodes"])

    map << "</map>\n"

  end
end
