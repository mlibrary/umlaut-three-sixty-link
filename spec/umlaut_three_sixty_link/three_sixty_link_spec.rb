require 'spec_helper'
require 'umlaut-three-sixty-link'

RSpec.describe UmlautThreeSixtyLink do
  let(:weight) do
    {
      "DCD" => 1,
      "7FN" => 2,
      "FXG" => 3,
      "TRM" => 4,
    }
  end
  let(:provider) do
    {
      "DCD" => "PRVBGY",
      "7FN" => "PRVBGY",
      "FXG" => "PRVACK",
      "TRM" => "PRVSPB",
    }
  end
  describe '::load_config' do
    it 'loads a hash' do
      described_class.load_config(File.dirname(__FILE__) + '/data/360link.yml')
      expect(described_class.weight).to eql(weight)
      expect(described_class.provider).to eql(provider)
    end
  end
end
