Given("the name opf the mindmap file is set to {string}") do |featuremap_file|
  create_path(@path_to_results)
  @featuremap_file = "#{@path_to_results}/#{featuremap_file}"
end

Given("it contains a feature without tags") do
  create_feature("#{@path_to_testdata}/#{@feature_dir}", "dummy.feature", [], {"tags" => ""})
end

Given("it contains a feature {string} with the tag {string}") do |feature, tag|
  create_feature("#{@path_to_testdata}/#{@feature_dir}", "#{feature}.feature", [], {"feature" => feature, "tags" => "#{tag}"})
end

Given("the feature dir contains features with mutliple tags") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  features_path = "#{@path_to_testdata}/#{@feature_dir}"
  table.hashes.each do |table_row|
    create_feature(features_path, "#{table_row["feature"]}.feature", [], {"feature" => table_row["feature"], "tags" => table_row["tags"].gsub(/,/," ")})
  end
end

Given("it contains a subdir {string}") do |subdir|
  @subdir_path = "#{@path_to_testdata}/#{@feature_dir}/#{subdir}"
  create_path(@subdir_path)
end

Given("the subdir contains a feature {string} with the tag {string}") do |feature, tag|
  create_feature(@subdir_path, "#{feature}.feature", [], {"feature" => feature, "tags" => tag})
end

Then("the root node has a tag child node {string}") do |tag|
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_') and @TEXT = '#{tag}']").count).to eq(1)
end

Then("the tag child node is marked by an paper clip icon") do
  expect(@mindmap.xpath("//node[starts-with(@ID,'tag_')]/icon[@BUILTIN = 'attach']").count).to eq(1)
end

Then("the tag child contains a feature node named {string}") do |feature|
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_')]/node[starts-with(@ID,'feature_')  and @TEXT = '#{feature}']").count).to eq(1)
end

Then("the mindmap shows tag nodes with feature nodes") do |table|
  table.hashes.each do |table_row|
    tag = table_row["tag_node"]
    features = table_row["features"].split(",")
    features.each do |feature|
      expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_') and  @TEXT = '#{tag}']").count).to eq(1)
      expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_') and  @TEXT = '#{tag}']/node[starts-with(@ID,'feature_') and @TEXT = '#{feature}']").count).to eq(1)
    end
  end
end

Then("the tag child contains the feature nodes {string} and {string}") do |feature1, feature2|
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_')]/node[starts-with(@ID,'feature_') and @TEXT = '#{feature1}']").count).to eq(1)
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_')]/node[starts-with(@ID,'feature_') and @TEXT = '#{feature2}']").count).to eq(1)
end

Then("the mindmap contains a tag node {string}") do |tag|
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_') and @TEXT = '#{tag}']").count).to eq(1)
end

Then("the font of the {string} tag node uses grey color") do |tag|
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_') and @TEXT = '#{tag}' and @COLOR = '#999999']").count).to eq(1)
end

Then("the feature node is attached to the tag node") do
  expect(@mindmap.xpath("/map/node[starts-with(@ID,'root_')]/node[starts-with(@ID,'tag_')]/node[starts-with(@ID,'feature_')]").count).to eq(1)
end
