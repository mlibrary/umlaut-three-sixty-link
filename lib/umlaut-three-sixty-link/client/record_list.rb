# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class RecordList
      include Enumerable

      def initialize(records, disambiguation = false)
        @records = records
        @disambiguation = disambiguation
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
        if disambiguation?
          @records.each do |record|
            base = { service: service, service_type_value: 'disambiguation' }
            record.add_disambiguation(request, base)
          end
        else
          @records.each do |record|
            base = { service: service, service_type_value: 'fulltext' }
            record.add_fulltext(request, base)
          end
        end
      end
      # :nocov:

      def disambiguation?
        @disambiguation
      end

      def self.from_xml(xml)
        records_with_links = 0
        parsed = Nokogiri::XML(xml)
        records = parsed.xpath('//ssopenurl:result').map do |parsed_xml|
          record = Record.from_parsed_xml(parsed_xml)
          records_with_links = records_with_links + 1 if record.link?
          record
        end
        new(records, records_with_links > 1)
      end
    end
  end
end
