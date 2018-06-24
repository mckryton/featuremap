# generate feature files as test data
# path: location of  tthe feature file
# name: name of the feature
def create_feature(path, name)

  feature = <<DUMMY_FEATURE
Feature: dummy feature for testing
  This is a dummy just for testing purposes

  Scenario: feature containing a scenario
    Given something
    When action
    Then result
DUMMY_FEATURE

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
  IO.write("#{path}/#{name}", content)
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
