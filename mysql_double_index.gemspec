# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mysql_double_index/version'

Gem::Specification.new do |spec|
  spec.name          = "mysql_double_index"
  spec.version       = MysqlDoubleIndex::VERSION
  spec.authors       = ["sunyafei"]
  spec.email         = ["1752709589@qq.com"]

  spec.summary       = %q{查找mysql数据库中重复和冗余索引}
  spec.description   = %q{查找mysql数据库中重复和冗余索引}
  spec.homepage      = "https://github.com/sun1752709589"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "activerecord", "~> 4.2"
  spec.add_development_dependency "terminal-table", "~> 1.5"
  spec.add_development_dependency "mysql2", "~> 0.3"
  spec.add_development_dependency "rails", "~> 4.2"
end
