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

    all[:a] = new(:a, nil, PinyinFinal[:a])
    all[:o] = new(:o, nil, PinyinFinal[:o])
    all[:e] = new(:e, nil, PinyinFinal[:e])
    all[:ai] = new(:ai, nil, PinyinFinal[:ai])
    all[:ei] = new(:ei, nil, PinyinFinal[:ei])
    all[:ao] = new(:ao, nil, PinyinFinal[:ao])
    all[:ou] = new(:ou, nil, PinyinFinal[:ou])
    all[:an] = new(:an, nil, PinyinFinal[:an])
    all[:en] = new(:en, nil, PinyinFinal[:en])
    all[:ang] = new(:ang, nil, PinyinFinal[:ang])
    all[:eng] = new(:eng, nil, PinyinFinal[:eng])
    all[:er] = new(:er, nil, PinyinFinal[:er])
    all[:yi] = new(:yi, nil, PinyinFinal[:i])
    all[:ya] = new(:ya, nil, PinyinFinal[:ia])
    all[:yo] = new(:yo, nil, PinyinFinal[:io])
    all[:ye] = new(:ye, nil, PinyinFinal[:ie])
    all[:yao] = new(:yao, nil, PinyinFinal[:iao])
    all[:you] = new(:you, nil, PinyinFinal[:iu])
    all[:yan] = new(:yan, nil, PinyinFinal[:ian])
    all[:yin] = new(:yin, nil, PinyinFinal[:in])
    all[:yang] = new(:yang, nil, PinyinFinal[:iang])
    all[:ying] = new(:ying, nil, PinyinFinal[:ing])
    all[:yong] = new(:yong, nil, PinyinFinal[:iong])
    all[:wu] = new(:wu, nil, PinyinFinal[:u])
    all[:wa] = new(:wa, nil, PinyinFinal[:ua])
    all[:wo] = new(:wo, nil, PinyinFinal[:uo])
    all[:wai] = new(:wai, nil, PinyinFinal[:uai])
    all[:wei] = new(:wei, nil, PinyinFinal[:ui])
    all[:wan] = new(:wan, nil, PinyinFinal[:uan])
    all[:wen] = new(:wen, nil, PinyinFinal[:un])
    all[:wang] = new(:wang, nil, PinyinFinal[:uang])
    all[:weng] = new(:weng, nil, PinyinFinal[:ueng])
    all[:yu] = new(:yu, nil, PinyinFinal[:v])
    all[:yue] = new(:yue, nil, PinyinFinal[:ve])
    all[:yuan] = new(:yuan, nil, PinyinFinal[:van])
    all[:yun] = new(:yun, nil, PinyinFinal[:vn])
  end.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end

  def as_json(*)
    { letters: letters, initial: initial, final: final }
  end
end
