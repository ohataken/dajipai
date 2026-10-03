require 'rails_helper'

RSpec.describe PinyinSyllable do
  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinSyllable.new }.to raise_error(NoMethodError)
    end
  end
end
