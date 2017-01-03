# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class RecordList
      include Enumerable

      ATTRIBUTES = %w(btitle atitle au date issn eissn volume issue doi jtitle spage epage)

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
        return if disambiguation?
        rft = request.referent
        ATTRIBUTES.each do |attribute|
          if rft.metadata[attribute].nil? || rft.metadata[attribute].empty?
            value = send(attribute)
            rft.enhance_referent(attribute, value) if value
          end
        end
      end

      # :nocov:
      def add_service(request, service)
        if @records.length == 0
          context = request.referent.to_context_object.to_hash
          ids = context['rft_id'] || []
          if ids.any? { |id| id.start_with?('info:pmid') }
            request.add_service_response(
              service: service,
              service_type_value: 'site_message',
              type: 'warning',
              message: 'umlaut.message.pubmed_unavailable'
            )
          elsif ids.any { |id| id.start_with?('info:doi') }
            request.add_service_response(
              service: service,
              service_type_value: 'site_message',
              type: 'warning',
              message: 'umlaut.message.doi_unavailable'
            )
          end
          return false
        end
        if disambiguation?
          selected = disambiguate(request)
          if selected
            base = {service: service, service_type_value: 'fulltext'}
            selected.add_fulltext(request, base)
          else
            @records.each_with_index do |record, i|
              base = { service: service, service_type_value: 'disambiguation' }
              record.add_disambiguation(request, base, i)
            end
          end
        else
          @records.each do |record|
            base = { service: service, service_type_value: 'fulltext' }
            record.add_fulltext(request, base)
          end
        end
        return true
      end
      # :nocov:

      def disambiguate(request)
        criteria = request.referent.metadata['select']
        if criteria && criteria.respond_to?(:to_i)
          criteria = criteria.to_i
          if criteria >= 0 && criteria < @records.length
            return @records[criteria]
          end
        end
        return nil
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
        urls = []
        records = parsed.xpath('//ssopenurl:result').map do |parsed_xml|
          record = Record.from_parsed_xml(parsed_xml)
          best = record.best_links
          if record.link?
            if (urls & best).empty?
              records_with_links = records_with_links + 1 if record.link?
              urls = urls + best
              record
            else
              nil
            end
          else
            record
          end
        end.compact
        new(records, records_with_links > 1)
      end
    end
  end
end
