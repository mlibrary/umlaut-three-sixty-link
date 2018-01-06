require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::LinkGroup do
  let(:link) do
    xml = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    parsed = Nokogiri::XML(xml)
    result = parsed.xpath('//ssopenurl:result').first
    UmlautThreeSixtyLink::Client::Record.from_parsed_xml(result).links.first
  end

  let(:lg) do
    described_class.new
  end

  describe '#dates' do
    it 'is empty when there aren\'t date' do
      expect(lg.dates).to eq('')
    end

    it 'is like (start date - ...)' do
      lg.holdings.start_date = '2000'
      expect(lg.dates).to eq(' (2000 - ...)')
    end

    it 'is like (... - end date)' do
      lg.holdings.end_date = '2001'
      expect(lg.dates).to eq(' (... - 2001)')
    end

    it 'is like (start date - end date)' do
      lg.holdings.end_date = '2001'
      lg.holdings.start_date = '2000'
      expect(lg.dates).to eq(' (2000 - 2001)')
    end
  end

  describe '#empty?' do
    it 'is true when empty' do
      expect(lg.empty?).to be(true)
    end
    it 'is false when not empty' do
      expect(link.empty?).to be(false)
    end
  end

  describe '#holdings' do
    it 'has holdings' do
      holdings = link.holdings
      expect(holdings.start_date).to eq('1972')
      expect(holdings.end_date).to eq('')
      expect(holdings.provider_id).to eq('PRVESC')
      expect(holdings.database_id).to eq('FDB')
      expect(holdings.provider_name).to eq('Elsevier')
      expect(holdings.database_name).to eq('ScienceDirect (Online service)')
    end
  end

  describe '#urls' do
    it 'has urls' do
      urls = link.urls
      expect(urls.source).to eq('http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com')
      expect(urls.journal).to eq('http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/science/journal/00100277')
      expect(urls.article).to be(nil)
    end
  end
end
