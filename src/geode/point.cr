module Geode
  class Point
    include Enumerable(Number)

    getter x
    getter y

    def self.collinear?(p1 : Point, p2 : Point, p3 : Point)
      num = ((p1.x * (p2.y - p3.y)) + 
             (p2.x * (p3.y - p1.y)) +
             (p3.x * (p1.y - p2.y)))

      -0.01 <= num && num <= 0.01 # precision limit
    end

    def initialize(@x : Number::Primitive = 0, @y : Number::Primitive = 0)
    end

    def_equals_and_hash(to_a)

    def each
      yield @x
      yield @y
    end

    def to_s
      sprintf("(%g, %g)", @x, @y)
    end
  end
end
