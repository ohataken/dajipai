require 'rails_helper'

RSpec.describe PinyinInitial do
  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinInitial.new }.to raise_error(NoMethodError)
    end
  end
end
