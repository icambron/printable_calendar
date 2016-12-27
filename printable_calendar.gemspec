# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "printable_calendar"
  spec.version       = "0.0.1"
  spec.authors       = ["Isaac Cambron"]
  spec.email         = ["isaac@isaaccambron.com"]

  spec.summary       = %q{Generate printable Google Calendar agendas}
  spec.homepage      = "http://github.com/icambron/printable_calendar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "google_calendar", "~> 0.6"
  spec.add_dependency "erector", "~> 0.10"
  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_dependency "slop", "~> 4.4"
  spec.add_dependency "launchy", "~> 2.4"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
