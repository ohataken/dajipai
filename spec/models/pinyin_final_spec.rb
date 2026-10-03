require 'rails_helper'

RSpec.describe PinyinFinal do
  describe ".new" do
    it "cannot be called from outside" do
      expect { PinyinFinal.new }.to raise_error(NoMethodError)
    end
  end
end
