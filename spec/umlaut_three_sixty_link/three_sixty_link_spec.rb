require 'spec_helper'
require 'umlaut-three-sixty-link'

RSpec.describe UmlautThreeSixtyLink do
  describe '::load_config' do
    it 'loads a hash' do
      described_class.load_config(File.dirname(__FILE__) + '/data/360link.yml')
      expect(described_class.weight).to eq('Weight')
      expect(described_class.provider).to eq('Provider')
    end
  end
end
