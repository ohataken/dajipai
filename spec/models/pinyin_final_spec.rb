require 'rails_helper'

RSpec.describe PinyinFinal do
  describe "::ALL" do
    it "holds finals as spelled after an initial" do
      expect(PinyinFinal::ALL.keys).to include(:iu, :ui, :un, :ong, :ue, :v)
    end

    it "does not hold the full forms of abbreviated finals" do
      expect(PinyinFinal::ALL.keys).not_to include(:iou, :uei, :uen)
    end

    it "keys the finals by their letters" do
      expect(PinyinFinal::ALL.all? { |letters, final| final.letters == letters }).to be(true)
    end
  end

  describe ".[]" do
    it "returns the same instance for the same letters" do
      expect(PinyinFinal[:ian]).to equal(PinyinFinal[:ian])
    end

    it "raises for unknown letters" do
      expect { PinyinFinal[:iou] }.to raise_error(KeyError)
    end
  end

  describe "#as_json" do
    it "serializes the letters" do
      expect(JSON.parse(PinyinFinal[:ian].to_json)).to eq("letters" => "ian")
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinFinal.new }.to raise_error(NoMethodError)
    end
  end
end
