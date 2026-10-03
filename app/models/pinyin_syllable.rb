class PinyinSyllable
  private_class_method :new

  attr_reader :letters, :initial, :final

  def initialize(letters, initial, final)
    @letters = letters
    @initial = initial
    @final = final
    freeze
  end
end
