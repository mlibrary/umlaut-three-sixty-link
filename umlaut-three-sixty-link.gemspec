# coding: utf-8

# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'umlaut-three-sixty-link/version'

Gem::Specification.new do |spec|
  spec.name          = 'umlaut-three-sixty-link'
  spec.version       = UmlautThreeSixtyLink::VERSION
  spec.authors       = ['Albert Bertram']
  spec.email         = ['bertrama@umich.edu']

  spec.summary       = 'Add 360Link(tm) to Umlaut'
  spec.description   = <<EOF
Umlaut is a link-resolver front-end.
360Link is a Link Resolver produced by ProQuest.
360Link and ProQuest are probably trade marks.
EOF
  spec.homepage      = 'https://github.com/mlibrary/umlaut-three-sixty-link'

  spec.licenses      = ['BSD-3-Clause']

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  spec.metadata['allowed_push_host'] = 'TODO: Set to \'http://mygemserver.com\''

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'openurl'
  spec.add_dependency 'simple_xlsx_reader'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
