# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/search/version'
require 'activerecord/base'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-search"
  spec.version       = Activerecord::Search::VERSION
  spec.date          = Time.now.strftime("%F")
  spec.authors       = ["Mehdi FARSI"]
  spec.email         = ["mehdifarsi.pro@gmail.com"]

  spec.summary       = %q{ActiveRecord::Search}
  spec.description   = %q{a lightweight search-engine using ActiveRecord}
  spec.homepage      = "https://github.com/mehdi-farsi/activerecord-search"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.post_install_message = <<-EOF
  Thanks for installing!
  You can follow me on:
    - Twitter: @farsi_mehdi
    - Github: mehdi-farsi

  This project permits to help to solve a common problem. My reward is to see you using it.

  So please, feel free to 'star' the project on GitHub:

  https://github.com/mehdi-farsi/activerecord-search
  
   Many Thanks !
  EOF

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "minitest"
end
