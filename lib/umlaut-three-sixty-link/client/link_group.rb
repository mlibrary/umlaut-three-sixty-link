module UmlautThreeSixtyLink
  module Client
    class LinkGroup
      attr_accessor :holdings, :urls

      def initialize(holdings = nil, urls = nil)
        @holdings = holdings || Holdings.new
        @urls     = urls     || Urls.new
      end

      def database_id
        @holdings.database_id
      end

      def empty?
        urls.empty?
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
        new(
          Holdings.from_parsed_xml(parsed_xml),
          Urls.from_parsed_xml(parsed_xml)
        )
      end
    end
  end
end
