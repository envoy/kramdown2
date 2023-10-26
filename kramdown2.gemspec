$LOAD_PATH.push File.expand_path("lib", __dir__)

require "kramdown2/version"

Gem::Specification.new do |spec|
  spec.name                              = "kramdown2"
  spec.version                           = Kramdown2::VERSION
  spec.authors                           = ["ridiculous"]
  spec.email                             = ["ryan.buckley@envoy.com"]
  spec.homepage                          = "https://github.com/ridiculous/kramdown2"
  spec.summary                           = "Kramdown but v2"
  spec.description                       = "Kramdown but v2.4"
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version             = '>= 2.7.8'
  spec.files                             = Dir["{lib}/**/*"]
  spec.license                           = "MIT"
  spec.add_dependency "rouge", "~> 4.2.0"
  spec.add_dependency "rexml", "~> 3.2.5"
end
