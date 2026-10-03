class PinyinFinal
  private_class_method :new

  attr_reader :letters

  def initialize(letters)
    @letters = letters
    freeze
  end

  ALL = {
    a: new(:a),
    o: new(:o),
    e: new(:e),
    ai: new(:ai),
    ei: new(:ei),
    ao: new(:ao),
    ou: new(:ou),
    an: new(:an),
    en: new(:en),
    ang: new(:ang),
    eng: new(:eng),
    ong: new(:ong),
    er: new(:er),
    i: new(:i),
    ia: new(:ia),
    io: new(:io),
    ie: new(:ie),
    iao: new(:iao),
    iu: new(:iu),
    ian: new(:ian),
    in: new(:in),
    iang: new(:iang),
    ing: new(:ing),
    iong: new(:iong),
    u: new(:u),
    ua: new(:ua),
    uo: new(:uo),
    uai: new(:uai),
    ui: new(:ui),
    uan: new(:uan),
    un: new(:un),
    uang: new(:uang),
    ueng: new(:ueng),
    ue: new(:ue),
    v: new(:v),
    ve: new(:ve),
    van: new(:van),
    vn: new(:vn)
  }.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end

  def as_json(*)
    { letters: letters }
  end
end
