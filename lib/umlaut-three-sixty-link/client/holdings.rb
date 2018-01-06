# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    # Represents the ssopenurl:holdingData xml element provided by 360Link.
    class Holdings
      PATHS = {
        end_date: './ssopenurl:holdingData/ssopenurl:endDate',
        start_date: './ssopenurl:holdingData/ssopenurl:startDate',
        provider_id: './ssopenurl:holdingData/ssopenurl:providerId',
        database_id: './ssopenurl:holdingData/ssopenurl:databaseId',
        provider_name: './ssopenurl:holdingData/ssopenurl:providerName',
        database_name: './ssopenurl:holdingData/ssopenurl:databaseName'
      }.freeze

      attr_accessor *PATHS.keys

      def initialize
        @provider_name = ''
        @database_name = ''
      end

      def start_date?
        !(start_date.nil? || start_date.empty?)
      end

      def end_date?
        !(end_date.nil? || end_date.empty?)
      end

      def self.from_parsed_xml(parsed_xml)
        holdings = new
        PATHS.each_pair do |name, path|
          holdings.send(name.to_s + '=', parsed_xml.xpath(path).inner_text)
        end
        holdings
      end
    end
  end
end
