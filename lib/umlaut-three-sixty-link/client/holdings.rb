module UmlautThreeSixtyLink
  module Client
    class Holdings
      attr_accessor :start_date,
        :end_date,
        :database_name,
        :database_id,
        :provider_name,
        :provider_id

      def start_date?
        !(start_date.nil? || start_date.empty?)
      end

      def end_date?
        !(end_date.nil? || end_date.empty?)
      end

      def self.from_parsed_xml(parsed_xml)
        holdings = new
        holdings.end_date      = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:endDate').inner_text
        holdings.start_date    = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:startDate').inner_text
        holdings.provider_id   = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:providerId').inner_text
        holdings.database_id   = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:databaseId').inner_text
        holdings.provider_name = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:providerName').inner_text
        holdings.database_name = parsed_xml.xpath('./ssopenurl:holdingData/ssopenurl:databaseName').inner_text
        holdings
      end
    end
  end
end
