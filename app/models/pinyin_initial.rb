class PinyinInitial
  private_class_method :new

  attr_reader :letters

  def initialize(letters)
    @letters = letters
    freeze
  end
end
