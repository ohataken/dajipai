class PinyinInitial
  private_class_method :new

  attr_reader :letters, :place_of_articulation

  def initialize(letters, place_of_articulation)
    @letters = letters
    @place_of_articulation = place_of_articulation
    freeze
  end

  ALL = {
    b: new(:b, :bilabial),
    p: new(:p, :bilabial),
    m: new(:m, :bilabial),
    f: new(:f, :labiodental),
    d: new(:d, :alveolar),
    t: new(:t, :alveolar),
    n: new(:n, :alveolar),
    l: new(:l, :alveolar),
    g: new(:g, :velar),
    k: new(:k, :velar),
    h: new(:h, :velar),
    j: new(:j, :palatal),
    q: new(:q, :palatal),
    x: new(:x, :palatal),
    zh: new(:zh, :retroflex),
    ch: new(:ch, :retroflex),
    sh: new(:sh, :retroflex),
    r: new(:r, :retroflex),
    z: new(:z, :dental),
    c: new(:c, :dental),
    s: new(:s, :dental)
  }.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end
end
