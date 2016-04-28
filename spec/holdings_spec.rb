require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::Holdings do

  before do
    @xml      = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    @parsed   = Nokogiri::XML(@xml)
    @result   = @parsed.xpath('//ssopenurl:result').first
    @record   = UmlautThreeSixtyLink::Client::Record.from_parsed_xml(@result)
    @holdings = @record.links.first.holdings
  end

  describe "#start_date?" do
    it "returns true" do
      expect(@holdings.start_date?).to be_truthy
    end
  end

  describe "#end_date?" do
    it "returns false" do
      expect(@holdings.end_date?).to be_falsey
    end
  end

end
