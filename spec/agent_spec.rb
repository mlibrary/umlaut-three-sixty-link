require 'spec_helper'
require 'umlaut-three-sixty-link/client'
require 'openurl'

RSpec.describe UmlautThreeSixtyLink::Client::Agent do
  before do
    @agent = UmlautThreeSixtyLink::Client::Agent.new("BASE", 5, 5)
  end

  describe '#handle' do
    it "creates a transport object" do
      transport_instance = instance_double('OpenURL::Transport')

      allow(transport_instance).to receive(:extra_args).and_return({})
      allow(transport_instance).to receive(:get).and_return(nil)
      allow(transport_instance).to receive(:response).and_return(nil)

      transport_class = class_double('OpenURL::Transport').as_stubbed_const
      allow(transport_class).to receive(:new).and_return(transport_instance)

      record_list_class = class_double('UmlautThreeSixtyLink::Client::RecordList').as_stubbed_const
      allow(record_list_class).to receive(:from_xml).and_return(nil)

      expect(transport_class)
        .to receive(:new).with("BASE", "CONTEXT", {:open_timeout=>5, :read_timeout=>5})
      expect(transport_instance).to receive(:extra_args)
      expect(transport_instance).to receive(:get)
      expect(transport_instance).to receive(:response)
      
      expect(record_list_class).to receive(:from_xml).with(nil)
      
      @agent.handle(nil, "CONTEXT")
    end
  end

end