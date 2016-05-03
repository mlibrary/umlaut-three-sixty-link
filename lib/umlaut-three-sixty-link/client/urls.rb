module UmlautThreeSixtyLink
  module Client
    class Urls
      attr_accessor :source, :journal, :article, :volume, :issue

      LEVELS = [:article, :issue, :volume, :journal, :source]

      def initialize
      end

      def list
        LEVELS.map { |level| get(level) }.compact
      end

      def dedupe(dedupe_urls = [])
        new_urls = self.class.new

        LEVELS.each do |level|
          value = get(level)
          if value
            normalized = value.chomp('/')
            unless dedupe_urls.include?(normalized)
              new_urls.set(level, value)
              dedupe_urls << normalized
            end
          end
        end

        if new_urls.list.empty?
          nil
        else
          new_urls
        end
      end

      def get(name)
        send(name.to_sym)
      end

      def set(name, value)
        send("#{name}=".to_sym, value)
      end

      def self.from_parsed_xml(parsed_xml)
        urls = Urls.new
        parsed_xml.xpath('./ssopenurl:url').each do |url|
          urls.set(url.attr('type'), url.inner_text)
        end
        urls
      end
    end
  end
end