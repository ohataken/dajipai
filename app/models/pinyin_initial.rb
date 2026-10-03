class PinyinInitial
  private_class_method :new

  attr_reader :letters, :place_of_articulation, :aspiration

  def initialize(letters, place_of_articulation, aspiration)
    @letters = letters
    @place_of_articulation = place_of_articulation
    @aspiration = aspiration
    freeze
  end

  ALL = {
    b: new(:b, :bilabial, :unaspirated),
    p: new(:p, :bilabial, :aspirated),
    m: new(:m, :bilabial, nil),
    f: new(:f, :labiodental, nil),
    d: new(:d, :alveolar, :unaspirated),
    t: new(:t, :alveolar, :aspirated),
    n: new(:n, :alveolar, nil),
    l: new(:l, :alveolar, nil),
    g: new(:g, :velar, :unaspirated),
    k: new(:k, :velar, :aspirated),
    h: new(:h, :velar, nil),
    j: new(:j, :palatal, :unaspirated),
    q: new(:q, :palatal, :aspirated),
    x: new(:x, :palatal, nil),
    zh: new(:zh, :retroflex, :unaspirated),
    ch: new(:ch, :retroflex, :aspirated),
    sh: new(:sh, :retroflex, nil),
    r: new(:r, :retroflex, nil),
    z: new(:z, :dental, :unaspirated),
    c: new(:c, :dental, :aspirated),
    s: new(:s, :dental, nil)
  }.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end
end
