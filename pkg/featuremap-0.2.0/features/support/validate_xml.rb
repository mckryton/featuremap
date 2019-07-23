def validate_mm(p_featuremap_path)
  mindmap_content = File.read(p_featuremap_path)
  validation_messages = validate_content(mindmap_content)
  return validation_messages
end

def validate_content(p_mindmap_content)
  schema = Nokogiri::XML::Schema(File.read("doc/definitions/freemind.xsd"))
  document = Nokogiri::XML(p_mindmap_content)
  validation_messages = schema.validate(document)
  validation_messages.each { |error_msg| @log.info "schema err: #{error_msg}"}
  return validation_messages
end
