# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'rails'
require 'umlaut-three-sixty-link'

module UmlautThreeSixtyLink
  # A railtie to:
  #   1. Register new service types
  #   2. Load the 360link.yml config
  #   3. Add rake tasks for creating the 360link configuration.
  class Railtie < Rails::Railtie
    initializer 'umlaut.preload' do
      require 'service_type_value'
      ServiceTypeValue.merge_hash!(
        fulltext_bundle: {
          display_name: 'Available Online',
          display_name_plural: 'Available Online'
        },
        disambiguation: {
          display_name: 'Disambiguation',
          display_name_plural: 'Disambiguations'
        },
        site_message: {
          display_name: 'Site Message',
          display_name_plural: 'Site Messages',
        }
      )
    end

    initializer 'umlaut_three_sixty_link.initialize' do
      require File.dirname(__FILE__) + '/service'
      UmlautThreeSixtyLink.load_config(Rails.root.join('config', '360link.yml'))
    end

    rake_tasks do
      load File.dirname(__FILE__) + '/rake_tasks.rake' if defined?(Rake)
    end
  end
end
