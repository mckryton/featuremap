# generate feature files as test data
# path: location of  tthe feature file
# name: name of the feature
def create_feature(path, name)
  puts "pending support/create_feature"

  create_path("test_data/#{path}")

  # feature file anlegen
end

def create_path(path)
  currentDir = Dir.getwd

  #Schleife for each item in path
  path.split('/').each do |dirname|
    currentDir = "#{currentDir}/#{dirname}"
    # prüfen ob Verzeichnis existiert
    if not Dir.exists?(dirname)
      # wenn nicht anlegen
      Dir.mkdir(currentDir)
    end
  end
end
