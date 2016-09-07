# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class RecordList
      include Enumerable

      ATTRIBUTES = %w(atitle au date issn eissn volume issue doi jtitle spage epage)

      attr_accessor *ATTRIBUTES

      def initialize(records, disambiguation = false)
        @records = records
        @disambiguation = disambiguation
        ATTRIBUTES.each do |attribute|
          send(attribute + '=', get_best(attribute))
        end
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
        rft = request.referent
        ATTRIBUTES.each do |attribute|
          value = send(attribute)
          rft.enhance_referent(attribute, value) if value
        end
      end

      # :nocov:
      def add_service(request, service)
        if disambiguation?
          selected = select(request)
          if selected
            base = {service: service, service_type_value: 'fulltext'}
            selected.add_fulltext(request, base)
          else
            @records.each do |record|
              base = { service: service, service_type_value: 'disambiguation' }
              record.add_disambiguation(request, base)
            end
          end
        else
          @records.each do |record|
            base = { service: service, service_type_value: 'fulltext' }
            record.add_fulltext(request, base)
          end
        end
      end
      # :nocov:

      def select(request)
        criteria = request.referent.metadata['select']
        @records.select do |record|
          record.match?(criteria)
        end.first
      end

      def first
        @records.first
      end

      def empty?
        @records.empty?
      end

      def link?
        @records.any?(&:link?)
      end

      def disambiguation?
        @disambiguation
      end

      def get_best(thing)
        options = @records.inject(Hash.new(0)) do |opt, record|
          val = record.send(thing)
          opt[val] = opt[val] + 1
          opt
        end

        options.sort_by(&:last).reverse.first.first unless options.empty?
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
