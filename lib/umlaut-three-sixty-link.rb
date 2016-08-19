# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'umlaut-three-sixty-link/version'
require 'umlaut-three-sixty-link/client'
if defined?(Rails)
  require 'umlaut-three-sixty-link/railtie'
  require 'search-methods/three-sixty-link'
end

# The top-level module
module UmlautThreeSixtyLink
  # Your code goes here...
  def self.load_config(file)
    @preferences = YAML.load_file(file)
  end

  def self.sort_link_groups(links)
    sorted = {}
    links.sort {|a,b| weight[a.database_id] <=> weight[b.database_id]}.each do |link|
      key = provider[link.database_id] || link.database_id
      sorted[key] ||= link
    end
    sorted.values
  end

  def self.weight
    @preferences[:weight] || Hash.new(0)
  end

  def self.provider
    @preferences[:provider] || {}
  end

end
