require 'rails_helper'

RSpec.describe PinyinSyllable do
  describe "::ALL" do
    it "holds a syllable with its initial and final" do
      syllable = PinyinSyllable::ALL[:zhuang]
      expect([ syllable.letters, syllable.initial, syllable.final ]).to eq([ :zhuang, PinyinInitial[:zh], PinyinFinal[:uang] ])
    end

    it "holds every combination of an initial and its finals" do
      expect(PinyinSyllable::ALL.size).to eq(PinyinInitial::ALL.values.sum { |initial| initial.finals.size })
    end

    it "does not hold combinations that do not exist" do
      expect(PinyinSyllable::ALL.keys).not_to include(:bv, :ja, :gi)
    end

    it "keys the syllables by their letters" do
      expect(PinyinSyllable::ALL.all? { |letters, syllable| syllable.letters == letters }).to be(true)
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinSyllable.new }.to raise_error(NoMethodError)
    end
  end
end
