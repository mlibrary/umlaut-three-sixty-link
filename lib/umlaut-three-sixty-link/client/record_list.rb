# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class RecordList
      include Enumerable

      def initialize(records)
        @records = records
      end

      def each(&block)
        @records.each(&block)
      end

      def [](index)
        @records[index]
      end

      def length
        @records.length
      end

      def enhance_metadata(request)
        # request.referent.enhance_referent("title", title)
        # request.referent.enhance_referent("au", author)
        # request.referent.enhance_referent("date", date)
      end

      # :nocov:
      def add_service(request, service)
        @records.each do |record|
          base = { service: service, service_type_value: 'fulltext' }
          record.add_service(request, base)
        end
      end
      # :nocov:

      def self.from_xml(xml)
        parsed = Nokogiri::XML(xml)
        records = parsed.xpath('//ssopenurl:result').map do |parsed_xml|
          Record.from_parsed_xml(parsed_xml)
        end
        new(records)
      end
    end
  end
end
