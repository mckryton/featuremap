# generate feature files as test data
# path: location of  tthe feature file
# name: name of the feature
def create_feature(path, name, scenarios = [], options = {})

  options = {"feature" => "dummy feature for testing", "tags" => ""}.merge(options)

  feature = <<DUMMY_FEATURE
#{options["tags"]}
Feature: #{options["feature"]}
  This is a dummy just for testing purposes
DUMMY_FEATURE


  scenarios.each do |scenario_name, scenario_type|
    feature += <<DUMMY_SCENARIO

#{scenario_type}: #{scenario_name}
  Given something
  When action
  Then result

DUMMY_SCENARIO
  end

  create_file(path, name, feature)
end


def create_other_file(path, name)

  content = <<DUMMY_TEXT
1,dummy,22
2,dummy,23
DUMMY_TEXT

  create_file(path, name, content)
end


def create_file(path, name, content)
  create_path(path)
  # file anlegen
  file = File.open("#{path}/#{name}", "w")
  file.print(content)
  file.close
end


def create_path(path)
  currentDir = Dir.getwd

  #Schleife for each item in path
  path.split('/').each do |dirname|
    currentDir = "#{currentDir}/#{dirname}"
    # prüfen ob Verzeichnis existiert
    if not Dir.exists?(currentDir)
      # wenn nicht anlegen
      Dir.mkdir(currentDir)
    end
  end
end


def delete_path(path)
  currentDir = Dir.getwd

  if Dir.exists?("#{currentDir}/#{path}")
    FileUtils.rm_rf(path)
  end
end
