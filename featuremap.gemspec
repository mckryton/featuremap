lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"

Gem::Specification.new do |s|
  s.name        = "featuremap"
  s.version     = Featuremap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthias Carell"]
  s.email       = ["rumpelcenter-featuremap at yahoo.com"]
  s.homepage    = "https://github.com/mckryton/featuremap"
  s.summary     = %q{A script to convert Gherkin features into a mindmap}
  s.description = %q{Featurmaps helps you to visualize the functionality of your \
    application by turning your Gherkin features into a mindmap}
  s.license     = "MIT"

  s.files         = `git ls-files`.split($/).grep(%r{^(bin|lib|features)/})
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_dependency("cuke_modeler")
end
