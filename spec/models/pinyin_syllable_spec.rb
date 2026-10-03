require 'rails_helper'

RSpec.describe PinyinSyllable do
  describe "::ALL" do
    it "holds a syllable with its initial and final" do
      syllable = PinyinSyllable::ALL[:zhuang]
      expect([ syllable.letters, syllable.initial, syllable.final ]).to eq([ :zhuang, PinyinInitial[:zh], PinyinFinal[:uang] ])
    end

    it "holds a syllable without an initial" do
      syllable = PinyinSyllable::ALL[:yan]
      expect([ syllable.letters, syllable.initial, syllable.final ]).to eq([ :yan, nil, PinyinFinal[:ian] ])
    end

    it "holds every combination of an initial and its finals and the 36 syllables without an initial" do
      expect(PinyinSyllable::ALL.size).to eq(PinyinInitial::ALL.values.sum { |initial| initial.finals.size } + 36)
    end

    it "does not hold combinations that do not exist" do
      expect(PinyinSyllable::ALL.keys).not_to include(:bv, :ja, :gi)
    end

    it "keys the syllables by their letters" do
      expect(PinyinSyllable::ALL.all? { |letters, syllable| syllable.letters == letters }).to be(true)
    end
  end

  describe ".[]" do
    it "returns the same instance for the same letters" do
      expect(PinyinSyllable[:he]).to equal(PinyinSyllable[:he])
    end

    it "raises for a syllable that does not exist" do
      expect { PinyinSyllable[:bv] }.to raise_error(KeyError)
    end
  end

  describe "#as_json" do
    it "serializes the letters with the initial and the final" do
      expect(JSON.parse(PinyinSyllable[:zai].to_json)).to eq(
        "letters" => "zai",
        "initial" => { "letters" => "z", "place_of_articulation" => "dental", "aspiration" => "unaspirated" },
        "final" => { "letters" => "ai" }
      )
    end

    it "serializes a syllable without an initial" do
      expect(JSON.parse(PinyinSyllable[:yan].to_json)).to eq("letters" => "yan", "initial" => nil, "final" => { "letters" => "ian" })
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinSyllable.new }.to raise_error(NoMethodError)
    end
  end
end
