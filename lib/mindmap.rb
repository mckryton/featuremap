class Mindmap

  def initialize

  end

  def create_featuremap(full_path)
    map = "<map version=\"1.0.1\">\n"
    map << "<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->\n"
    map << "<node CREATED=\"1521894039416\" ID=\"ID_969661523\" MODIFIED=\"1521894053215\" TEXT=\"featuremap\"/>\n"
    map << "</map>\n"

    IO.write("#{full_path}", map)
  end
end
