require 'rails'
require 'umlaut-three-sixty-link'

module UmlautThreeSixtyLink
  class Railtie < Rails::Railtie
    initializer "umlaut_three_sixty_link.initialize" do |app|
      require File.dirname(__FILE__) + '/service'
    end
    rake_tasks do
      load File.dirname(__FILE__) + '/rake_tasks.rake' if defined?(Rake)
    end
  end
end
