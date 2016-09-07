# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class Urls
      LEVELS = %w(directLink article issue volume journal source).freeze

      attr_accessor(*LEVELS, :structured_notes)

      alias_method :direct_link, :directLink
      alias_method :direct_link=, :directLink=

      def initialize
        @structured_notes = {}
      end

      def empty?
        list.empty?
      end

      def notes
        @structured_notes.values.uniq.join(' ')
      end

      def specificity
        case false
        when direct_link.nil?
          'direct_link'
        when article.nil?
          'article'
        when issue.nil?
          'issue'
        when volume.nil?
          'volume'
        when journal.nil?
          'journal'
        else
          'source'
        end
      end

      def best
        direct_link || article || issue || volume || journal || source
      end

      def list
        LEVELS.map { |level| send(level) }.compact
      end

      def self.from_parsed_xml(parsed_xml)
        urls = new
        parsed_xml.xpath('./ssopenurl:url').each do |url|
          urls.send(url.attr('type') + '=', url.inner_text)
        end
        parsed_xml.xpath('./ssopenurl:note').each do |note|
          type = note.attr('type').to_s.to_sym
          urls.structured_notes[type] ||= []
          urls.structured_notes[type] << note.inner_text.to_s
        end
        urls
      end
    end
  end
end
