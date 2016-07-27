module UmlautThreeSixtyLink
  module Client
    class Urls
      LEVELS = [:article, :issue, :volume, :journal, :source].freeze

      attr_accessor(*LEVELS, :notes, :structured_notes)

      def initialize
        @structured_notes = {}
      end

      def notes
        @structured_notes.values.uniq.join(' ')
      end

      def list
        LEVELS.map { |level| send(level) }.compact
      end

      def dedupe(dedupe_urls = [])
        new_urls = self.class.new

        LEVELS.each do |level|
          value = send(level)
          next unless value
          normalized = value.chomp('/')
          unless dedupe_urls.include?(normalized)
            new_urls.send(level.to_s + '=', value)
            dedupe_urls << normalized
          end
        end

        if new_urls.list.empty?
          nil
        else
          new_urls
        end
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
