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

      def dedupe
        new_list = []
        urls = []
        @records.each do |record|
          new_record = record.dedupe(urls)
          new_list << new_record unless new_record.nil?
        end
        RecordList.new(new_list)
      end

      def add_service(request, service)
        @records.each do |record|
          base = { service: service, service_type_value: 'fulltext' }
          record.add_service(request, base)
        end
      end

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
