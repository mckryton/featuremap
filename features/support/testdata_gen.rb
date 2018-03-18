# generate feature files as test data
# path: location of  tthe feature file
# name: name of the feature
def create_feature(path, name)

  test_path = "test_data/#{path}"
  create_path(test_path)

  feature = <<DUMMY_FEATURE
Feature: dummy feature for testing
  This is a dummy just for testing purposes

  Scenario: feature containing a scenario
    Given something
    When action
    Then result
DUMMY_FEATURE

  # feature file anlegen
  IO.write("#{test_path}/#{name}", feature)
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
