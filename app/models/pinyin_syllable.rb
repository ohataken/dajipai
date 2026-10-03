class PinyinSyllable
  private_class_method :new

  attr_reader :letters, :initial, :final

  def initialize(letters, initial, final)
    @letters = letters
    @initial = initial
    @final = final
    freeze
  end

  ALL = {}.tap do |all|
    PinyinInitial::ALL.each_value do |initial|
      initial.finals.each do |final|
        letters = :"#{initial.letters}#{final.letters}"
        all[letters] = new(letters, initial, final)
      end
    end
  end.freeze
end
