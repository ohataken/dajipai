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

  describe "#aspiration" do
    it "tells aspirated and unaspirated initials apart" do
      groups = PinyinInitial::ALL.values.group_by(&:aspiration).transform_values { |initials| initials.map(&:letters) }
      expect(groups).to eq(
        unaspirated: %i[b d g j zh z],
        aspirated: %i[p t k q ch c],
        nil => %i[m f n l h x sh r s]
      )
    end
  end

  describe "#finals" do
    it "lists the finals the initial combines with" do
      expect(PinyinInitial[:f].finals.map(&:letters)).to eq(%i[a o ei ou an en ang eng u])
    end

    it "returns the shared final instances" do
      expect(PinyinInitial[:b].finals.first).to equal(PinyinFinal[:a])
    end

    it "excludes finals the initial does not combine with" do
      expect(PinyinInitial[:b].finals).not_to include(PinyinFinal[:e], PinyinFinal[:ong])
      expect(PinyinInitial[:j].finals).not_to include(PinyinFinal[:a], PinyinFinal[:v])
      expect(PinyinInitial[:g].finals).not_to include(PinyinFinal[:i])
    end

    it "keeps v (ü) only after n and l" do
      expect(PinyinInitial::ALL.values.select { |initial| initial.finals.include?(PinyinFinal[:v]) }.map(&:letters)).to eq(%i[n l])
    end
  end

  describe "#as_json" do
    it "serializes the letters and properties without the finals" do
      expect(JSON.parse(PinyinInitial[:zh].to_json))
        .to eq("letters" => "zh", "place_of_articulation" => "retroflex", "aspiration" => "unaspirated")
      expect(JSON.parse(PinyinInitial[:m].to_json))
        .to eq("letters" => "m", "place_of_articulation" => "bilabial", "aspiration" => nil)
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinInitial.new }.to raise_error(NoMethodError)
    end
  end
end
