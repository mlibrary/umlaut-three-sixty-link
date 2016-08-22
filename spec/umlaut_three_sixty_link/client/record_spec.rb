require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::Record do
  before do
  end

  let(:record) do
    xml = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    UmlautThreeSixtyLink::Client::RecordList.from_xml(xml).first
  end

  let(:request) do
    double('Request', add_service_response: nil)
  end

  describe '#links' do
    it 'has links' do
      expect(record.links.length).to be(2)
    end
  end

  describe '#add_service' do
    it 'calls request.add_service_request()' do
      arguments = [
        {
          service_type_value: 'fulltext_bundle'
        },
        {
          display_text: 'Cognition',
          notes: 'Elsevier / ScienceDirect (Online service) (1972 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/science/journal/00100277'
        },
        {
          display_text: 'Cognition',
          notes: 'Elsevier / ScienceDirect (Online service) (1972 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com'
        },
        {
          display_text: 'Cognition',
          notes: 'Elsevier / ScienceDirect Freedom Collection (01/01/1995 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/science/journal/00100277'
        },
        {
          display_text: 'Cognition',
          notes: 'Elsevier / ScienceDirect Freedom Collection (01/01/1995 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/'
        }

      ]
      arguments.each do |argument|
        expect(request)
          .to receive(:add_service_response)
          .with(hash_including(argument))
      end
      record.add_service(request, {})
    end
  end

  describe '#display_text' do
    it 'gets the right string' do
      expect(record.display_text(:article)).to eq('Cognition')
      expect(record.display_text(:issue)).to eq('Cognition (): ')
      expect(record.display_text(:volume)).to eq('Cognition ()')
      expect(record.display_text(:journal)).to eq('Cognition')
      expect(record.display_text(:source)).to eq('Cognition')
    end
  end

  describe '#set' do
    it 'changes values' do
      record = described_class.new
      expect(record.creator).to eql(nil)
      record.set('creator', 'creator')
      expect(record.creator).to eql('creator')
    end

    it 'handles unknown properties' do
      record = described_class.new
      expect(record.other).to eql([])
      record.set('blah blah blah', 'value')
      expect(record.other).to eql(['blah blah blah => value'])
    end
  end
end
