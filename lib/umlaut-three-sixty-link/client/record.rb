# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    # Represents the ssopenurl:result element from xml provided by 360Link.
    class Record
      ATTRIBUTES = %w(creator source isbn issn other
                      issue volume spage epage title
                      eisbn eissn date format doi
      ).freeze

      SEPARATOR = ', '.freeze

      attr_accessor *ATTRIBUTES, :links

      def au
        creator
      end

      def atitle
        if title == source
          nil
        elsif journal? || book?
          title
        end
      end

      def jtitle
        source if journal?
      end

      def btitle
        source if book?
      end

      def book?
        format == 'book'
      end

      def journal?
        format == 'journal'
      end

      def initialize
        @other = []
        @links = []
      end

      def to_h
        new_hash = {}
        ATTRIBUTES.each do |attribute|
          new_hash[attribute] = send(attribute)
        end
        new_hash
      end

      def match?(data)
        data == disambiguate
      end

      def link?
        links.inject(false) { |val, link| val || !link.urls.empty? }
      end

      def disambiguate
        {source: source, isbn: isbn, issn: issn, eisbn: eisbn, eissn: eissn, creator: creator}.to_json
      end

      def best_links
        links.map {|link| link.urls.best}.compact
      end

      def add_disambiguation(request, base, i)
        return unless link?
        query = request.referent.to_context_object.to_hash.merge('rft.select' => i)
        request.add_service_response(
          base.merge(
            notes: links.map { |link| link.urls.notes }.compact.uniq,
            metadata: to_h,
            query: query
          )
        )
      end

      def add_fulltext(request, base)
        metadata = request.referent.metadata
        responses = {}
        links.each do |link|
          Urls::LEVELS.each do |level|
            if link.urls.send(level)
              response = request.add_service_response(
                base.merge(
                  display_text: display_text(level),
                  notes: link.notes,
                  url: link.urls.send(level)
                )
              )
              responses[response.url] = response.id
            end
          end
          request.add_service_response(
            base.merge(
              service_type_value: 'fulltext_bundle',
              format: request.referent.format,
              genre: metadata['genre'] || metadata['type'] || 'unknown',
              best: link.specificity,
              best_id: responses[link.urls.best],
              source_id: responses[link.urls.source],
              headings: {
                article: display_text('article'),
                journal: display_text('journal'),
                source: link.source,
                provider: link.holdings.provider_name,
                database: link.holdings.database_name
              },
              notes: link.urls.notes,
              structured_notes: link.urls.structured_notes,
              urls: link.urls,
              url: link.urls.best,
              available: {
                start: link.holdings.start_date,
                end: link.holdings.end_date
              }
            )
          )
        end
      end

      def display_text(level = 'article')
        case level
        when 'article', 'directLink'
          title || source
        when 'issue'
          "#{title || source} (#{volume}): #{issue}"
        when 'volume'
          "#{title || source} (#{volume})"
        when 'journal', 'source'
          source
        end
      end

      def set(name, value)
        if attribute?(name)
          send("#{name}=", value)
        else
          @other << "#{name} => #{value}"
        end
      end

      def self.from_parsed_xml(parsed_xml)
        record = Record.new
        record.format = format(parsed_xml)
        attributes(parsed_xml).each do |attribute|
          record.set(attribute.name, attribute.inner_text)
        end

        link_groups(parsed_xml).each do |link_group|
          record.links << link_group
        end
        record
      end

      def attribute?(name)
        self.class.attribute?(name)
      end

      def self.format(input)
        input.attr('format')
      end

      def self.attributes(input)
        input.xpath('./ssopenurl:citation/*')
      end

      def self.link_groups(input)
        links = []
        input.xpath('./ssopenurl:linkGroups/ssopenurl:linkGroup').each do |link_group|
          links << LinkGroup.from_parsed_xml(link_group)
        end
        UmlautThreeSixtyLink.sort_link_groups(links)
      end

      def self.attribute?(attribute)
        ATTRIBUTES.include?(attribute)
      end
    end
  end
end
