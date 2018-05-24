def validate_mm(p_featuremap_path)
  schema = Nokogiri::XML::Schema(File.read("doc/definitions/freemind.xsd"))
  document = Nokogiri::XML(File.read(p_featuremap_path))
  validation_messages = schema.validate(document)
  validation_messages.each { |error_msg| @log.info "schema err: #{error_msg}"}
  return validation_messages
end
