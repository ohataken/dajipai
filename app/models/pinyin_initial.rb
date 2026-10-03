class PinyinInitial
  private_class_method :new

  attr_reader :letters

  def initialize(letters)
    @letters = letters
    freeze
  end

  ALL = {
    b: new(:b),
    p: new(:p),
    m: new(:m),
    f: new(:f),
    d: new(:d),
    t: new(:t),
    n: new(:n),
    l: new(:l),
    g: new(:g),
    k: new(:k),
    h: new(:h),
    j: new(:j),
    q: new(:q),
    x: new(:x),
    zh: new(:zh),
    ch: new(:ch),
    sh: new(:sh),
    r: new(:r),
    z: new(:z),
    c: new(:c),
    s: new(:s)
  }.freeze

  def self.[](letters)
    ALL.fetch(letters)
  end
end
