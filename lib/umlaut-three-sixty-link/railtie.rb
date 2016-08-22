require 'rails'
require 'umlaut-three-sixty-link'

module UmlautThreeSixtyLink
  class Railtie < Rails::Railtie
    initializer 'umlaut.preload' do
      require 'service_type_value'
      ServiceTypeValue.merge_hash!(
        fulltext_bundle: {
          display_name: 'Available Online',
          display_name_plural: 'Available Online'
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
