require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::RecordList do
  let(:record_list) do
    xml = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    described_class.from_xml(xml)
  end

  describe '.from_xml' do
    it 'parses xml' do
      expect(record_list.length).to be(1)
    end
  end

  describe '#[]' do
    it 'retrieves records' do
      expect(record_list[0]).to be_a(UmlautThreeSixtyLink::Client::Record)
    end
  end

  describe '#each' do
    it 'yields blocks' do
      counter = 0
      record_list.each do
        counter += 1
      end
      expect(counter).to be(1)
    end
  end

  describe '#dedupe' do
    it 'removes duplicates' do
      deduped = record_list.dedupe
      expect(deduped).to be_a(described_class)
      expect(deduped[0].links.length).to be(2)
    end
  end
end
