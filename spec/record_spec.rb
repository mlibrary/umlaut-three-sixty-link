require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::Record do

  before do
    @xml = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    @record = UmlautThreeSixtyLink::Client::Record.from_xml(@xml).first

    @request = double('Request', :add_service_response => nil)

  end

  describe "#links" do
    it "has links" do
      expect(@record.links.length).to be(2)
    end
  end

  describe '#add_service' do
    it "calls request.add_service_request()" do
      arguments = [
        {
          display_text: 'Cognition',
          notes: 'Journal-level: Elsevier / ScienceDirect (Online service) (1972 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/science/journal/00100277'
        },
        {
          display_text: 'Elsevier / ScienceDirect (Online service)',
          notes: 'Database-level: Elsevier / ScienceDirect (Online service) (1972 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com'
        },
        {
          display_text: 'Cognition',
          notes: 'Journal-level: Elsevier / ScienceDirect Freedom Collection (01/01/1995 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/science/journal/00100277'
        },
        {
          display_text: 'Elsevier / ScienceDirect Freedom Collection',
          notes: 'Database-level: Elsevier / ScienceDirect Freedom Collection (01/01/1995 - ...)',
          url: 'http://proxy.lib.umich.edu/login?url=http://www.sciencedirect.com/'
        }

      ]
      arguments.each do |argument|
        expect(@request)
          .to receive(:add_service_response)
          .with(hash_including(argument))
      end
      @record.add_service(@request, {})
    end
  end

  describe '#display_text' do
    it "gets the right string" do
      expect(@record.display_text(:article)).to eq("Cognition")
      expect(@record.display_text(:issue)).to eq("Cognition (): ")
      expect(@record.display_text(:volume)).to eq("Cognition ()")
      expect(@record.display_text(:journal)).to eq("Cognition")
      expect(@record.display_text(:source)).to eq("Cognition")
    end
  end

  describe "#set" do
    it "changes values" do
      record = UmlautThreeSixtyLink::Client::Record.new
      expect(record.creator).to eql(nil)
      record.set("creator", "creator")
      expect(record.creator).to eql("creator")
    end

    it "handles unknown properties" do
      record = UmlautThreeSixtyLink::Client::Record.new
      expect(record.other).to eql([])
      record.set('blah blah blah', 'value')
      expect(record.other).to eql(['blah blah blah => value'])
    end
  end

  describe "#to_s" do
    it "returns a string" do
      expect(@record.to_s.is_a?(String)).to be_truthy
    end
  end

  describe "#to_hash" do
    before do
      @hash = @record.to_hash
    end

    it "is_a hash" do
      expect(@hash.is_a?(Hash)).to be_truthy
    end

    it "has keys" do
      expect(@hash.keys.length).to be > 0
    end

    it "gets the right source" do
      expect(@hash[:source]).to eql("Cognition")
    end

    it "gets the right issn" do
      expect(@hash[:issn]).to eql("0010-0277")
    end
  end
end