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
end
