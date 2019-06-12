#$LOAD_PATH.push File.expand_path("lib/", __FILE__)
#require "featuremap/version"

Gem::Specification.new do |s|
  s.name        = "featuremap"
#  s.version     = Featuremap::VERSION
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthias Carell"]
  s.email       = ["rumpelcenter-featuremap at yahoo.com"]
  s.homepage    = "https://github.com/mckryton/featuremap"
  s.summary     = %q{A script to convert Gherkin features into a mindmap}
  s.description = %q{Featurmaps helps you to visualize the functionality of your \
    application by presenting your features as a mindmap}

  s.rubyforge_project = "featuremap"

  s.files       = ["bin/featuremap", "lib/featuremap.rb","lib/mindmap.rb"]
  s.executables = ["featuremap"]
end
