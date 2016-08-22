require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::Urls do
  let(:factiva) do
    xml = IO.read(File.dirname(__FILE__) + '/data/factiva.xml')
    parsed = Nokogiri::XML(xml)
    result = parsed.xpath('//ssopenurl:result').first
    UmlautThreeSixtyLink::Client::Record.from_parsed_xml(result).links.first.urls
  end

  let(:blank) do
    described_class.new
  end

  describe '#notes' do
    it 'returns an empty string' do
      expect(blank.notes).to eq('')
    end

    it 'returns a single string' do
      expect(factiva.notes).to eq('Takes you to the front page of Factiva where you may search again.')
    end
  end

  describe '#structured_notes' do
    it 'retuns an empty hash when empty' do
      expect(blank.structured_notes.empty?).to be(true)
    end

    it 'returns a hash with data' do
      expect(factiva.structured_notes[:database][0]).to eq('Takes you to the front page of Factiva where you may search again.')
    end
  end
end
