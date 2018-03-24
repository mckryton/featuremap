require 'nokogiri'

def validate_mm(p_featuremap_path)
  schema = Nokogiri::XML::Schema(File.read("doc/definitions/freemind.xsd"))
  document = Nokogiri::XML(File.read(p_featuremap_path))
  schema.validate(document)
end
