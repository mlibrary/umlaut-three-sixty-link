require 'spec_helper'
require 'umlaut-three-sixty-link/client'

RSpec.describe UmlautThreeSixtyLink::Client::RecordList do

  before do
    @xml = IO.read(File.dirname(__FILE__) + '/data/cognition.xml')
    @record_list = UmlautThreeSixtyLink::Client::RecordList.from_xml(@xml)
  end

  describe ".from_xml" do
    it "parses xml" do
      expect(@record_list.length).to be(1)
    end
  end

  describe "#[]" do
    it "retrieves records" do
      expect(@record_list[0]).to be_a(UmlautThreeSixtyLink::Client::Record)
    end
  end

  describe "#each" do
    before do
      @counter = 0
      @record_list.each do |record|
        @counter = @counter + 1
      end
    end

    it "yields blocks" do
      expect(@counter).to be(1)
    end
  end

  describe "#dedupe" do
    before do
      @deduped = @record_list.dedupe
    end

    it "removes duplicates" do
      expect(@deduped).to be_a(UmlautThreeSixtyLink::Client::RecordList)
      expect(@deduped[0].links.length).to be(1)
    end
  end
end