# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'umlaut-three-sixty-link/version'
require 'umlaut-three-sixty-link/client'

# :nocov:
if defined?(Rails)
  require 'umlaut-three-sixty-link/railtie'
  require 'search-methods/three-sixty-link'
end
# :nocov:

# The top-level module
module UmlautThreeSixtyLink
  DEFAULT_WEIGHT = 1000000

  def self.load_config(file)
    @preferences = YAML.load_file(file)
  end

  def self.sort_link_groups(links)
    sorted = {}
    links.sort_by do |link|
      weight[link.database_id] || DEFAULT_WEIGHT
    end.each do |link|
      key = provider[link.database_id] || link.database_id
      sorted[key] ||= link
    end
    sorted.values
  end

  def self.weight
    preferences[:weight] ||= Hash.new(DEFAULT_WEIGHT)
  end

  def self.provider
    preferences[:provider] || {}
  end

  def self.preferences
    @preferences ||= {}
  end

end
