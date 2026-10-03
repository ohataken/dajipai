class PinyinInitial
  private_class_method :new

  attr_reader :letters, :place_of_articulation, :aspiration, :finals

  def initialize(letters, place_of_articulation, aspiration, finals)
    @letters = letters
    @place_of_articulation = place_of_articulation
    @aspiration = aspiration
    @finals = finals.map { |final| PinyinFinal[final] }.freeze
    freeze
  end

  ALL = {
    b: new(:b, :bilabial, :unaspirated, %i[a o ai ei ao an en ang eng i ie iao ian in ing u]),
    p: new(:p, :bilabial, :aspirated, %i[a o ai ei ao ou an en ang eng i ie iao ian in ing u]),
    m: new(:m, :bilabial, nil, %i[a o e ai ei ao ou an en ang eng i ie iao iu ian in ing u]),
    f: new(:f, :labiodental, nil, %i[a o ei ou an en ang eng u]),
    d: new(:d, :alveolar, :unaspirated, %i[a e ai ei ao ou an en ang eng ong i ia ie iao iu ian ing u uo ui uan un]),
    t: new(:t, :alveolar, :aspirated, %i[a e ai ao ou an ang eng ong i ie iao ian ing u uo ui uan un]),
    n: new(:n, :alveolar, nil, %i[a e ai ei ao ou an en ang eng ong i ie iao iu ian in iang ing u uo uan v ve]),
    l: new(:l, :alveolar, nil, %i[a e ai ei ao ou an ang eng ong i ia ie iao iu ian in iang ing u uo uan un v ve]),
    g: new(:g, :velar, :unaspirated, %i[a e ai ei ao ou an en ang eng ong u ua uo uai ui uan un uang]),
    k: new(:k, :velar, :aspirated, %i[a e ai ei ao ou an en ang eng ong u ua uo uai ui uan un uang]),
    h: new(:h, :velar, nil, %i[a e ai ei ao ou an en ang eng ong u ua uo uai ui uan un uang]),
    j: new(:j, :palatal, :unaspirated, %i[i ia ie iao iu ian in iang ing iong u ue uan un]),
    q: new(:q, :palatal, :aspirated, %i[i ia ie iao iu ian in iang ing iong u ue uan un]),
    x: new(:x, :palatal, nil, %i[i ia ie iao iu ian in iang ing iong u ue uan un]),
    zh: new(:zh, :retroflex, :unaspirated, %i[a e ai ei ao ou an en ang eng ong i u ua uo uai ui uan un uang]),
    ch: new(:ch, :retroflex, :aspirated, %i[a e ai ao ou an en ang eng ong i u ua uo uai ui uan un uang]),
    sh: new(:sh, :retroflex, nil, %i[a e ai ei ao ou an en ang eng i u ua uo uai ui uan un uang]),
    r: new(:r, :retroflex, nil, %i[e ao ou an en ang eng ong i u ua uo ui uan un]),
    z: new(:z, :dental, :unaspirated, %i[a e ai ei ao ou an en ang eng ong i u uo ui uan un]),
    c: new(:c, :dental, :aspirated, %i[a e ai ao ou an en ang eng ong i u uo ui uan un]),
    s: new(:s, :dental, nil, %i[a e ai ao ou an en ang eng ong i u uo ui uan un])
  }.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end
end
