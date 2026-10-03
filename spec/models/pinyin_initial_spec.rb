require 'rails_helper'

RSpec.describe PinyinInitial do
  describe "::ALL" do
    it "holds the 21 initials keyed by their letters" do
      expect(PinyinInitial::ALL.keys).to eq(%i[b p m f d t n l g k h j q x zh ch sh r z c s])
      expect(PinyinInitial::ALL.all? { |letters, initial| initial.letters == letters }).to be(true)
    end
  end

  describe ".[]" do
    it "returns the same instance for the same letters" do
      expect(PinyinInitial[:zh]).to equal(PinyinInitial[:zh])
    end

    it "raises for unknown letters" do
      expect { PinyinInitial[:v] }.to raise_error(KeyError)
    end
  end

  describe "#place_of_articulation" do
    it "groups the initials by where they are articulated" do
      groups = PinyinInitial::ALL.values.group_by(&:place_of_articulation).transform_values { |initials| initials.map(&:letters) }
      expect(groups).to eq(
        bilabial: %i[b p m],
        labiodental: %i[f],
        alveolar: %i[d t n l],
        velar: %i[g k h],
        palatal: %i[j q x],
        retroflex: %i[zh ch sh r],
        dental: %i[z c s]
      )
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinInitial.new }.to raise_error(NoMethodError)
    end
  end
end
