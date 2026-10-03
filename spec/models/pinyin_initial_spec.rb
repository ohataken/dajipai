require 'rails_helper'

RSpec.describe PinyinInitial do
  describe "::ALL" do
    it "holds the 21 initials keyed by their letters" do
      expect(PinyinInitial::ALL.keys).to eq(%i[b p m f d t n l g k h j q x zh ch sh r z c s])
      expect(PinyinInitial::ALL.all? { |letters, initial| initial.letters == letters }).to be(true)
    end
  end

  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinInitial.new }.to raise_error(NoMethodError)
    end
  end
end
