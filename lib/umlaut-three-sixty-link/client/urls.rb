module UmlautThreeSixtyLink
  module Client
    class Urls
      attr_accessor :source, :journal, :article, :volume, :issue

      def initialize
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