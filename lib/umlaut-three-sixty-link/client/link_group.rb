module UmlautThreeSixtyLink
  module Client
    class LinkGroup
      attr_accessor :holdings, :urls

      def initialize(holdings = nil, urls = nil)
        @holdings = holdings || Holdings.new
        @urls     = urls     || Urls.new
      end

      def dedupe(dedupe_urls=[])
        new_link = self.class.new(@holdings)
        new_link.urls = @urls.dedupe(dedupe_urls)

        if new_link.urls.nil?
          nil
        else
          new_link
        end
      end

      def dates
        if holdings.start_date? && holdings.end_date?
          " (#{holdings.start_date} - #{holdings.end_date})"
        elsif holdings.start_date?
          " (#{holdings.start_date} - ...)"
        elsif holdings.end_date?
          " (... - #{holdings.end_date})"
        else
          ''
        end
      end

      def notes
        source + dates
      end

      def source
        holdings.provider_name + ' / ' + holdings.database_name
      end

      def self.from_parsed_xml(parsed_xml)
        LinkGroup.new(
          Holdings.from_parsed_xml(parsed_xml),
          Urls.from_parsed_xml(parsed_xml)
        )
      end
    end
  end
end
