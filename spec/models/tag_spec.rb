require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "validations" do
    it "is valid with a name and slug" do
      expect(Tag.new(name: "動詞", slug: "verbs")).to be_valid
    end

    it "requires a name" do
      tag = Tag.new(name: nil, slug: "verbs")
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it "requires a slug" do
      tag = Tag.new(name: "動詞", slug: nil)
      expect(tag).not_to be_valid
      expect(tag.errors[:slug]).to include("can't be blank")
    end

    it "requires name to be unique" do
      Tag.create!(name: "動詞", slug: "verbs")
      tag = Tag.new(name: "動詞", slug: "verbs-2")
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("has already been taken")
    end

    it "requires slug to be unique" do
      Tag.create!(name: "動詞", slug: "verbs")
      tag = Tag.new(name: "名詞", slug: "verbs")
      expect(tag).not_to be_valid
      expect(tag.errors[:slug]).to include("has already been taken")
    end

    describe "slug format" do
      it "accepts lowercase letters, digits, and hyphens" do
        expect(Tag.new(name: "HSK 4", slug: "hsk-4")).to be_valid
      end

      it "rejects uppercase letters" do
        tag = Tag.new(name: "Verbs", slug: "Verbs")
        expect(tag).not_to be_valid
        expect(tag.errors[:slug]).to include("is invalid")
      end

      it "rejects spaces" do
        tag = Tag.new(name: "hsk 4", slug: "hsk 4")
        expect(tag).not_to be_valid
        expect(tag.errors[:slug]).to include("is invalid")
      end

      it "rejects underscores" do
        tag = Tag.new(name: "hsk", slug: "hsk_4")
        expect(tag).not_to be_valid
        expect(tag.errors[:slug]).to include("is invalid")
      end

      it "rejects non-ASCII characters" do
        tag = Tag.new(name: "動詞", slug: "動詞")
        expect(tag).not_to be_valid
        expect(tag.errors[:slug]).to include("is invalid")
      end
    end
  end
end
