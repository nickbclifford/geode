module Geode
  # The `Point` class represents a point on the 2-dimensional Cartesian plane.
  class Point
    include Enumerable(Number::Primitive)

    # Returns the x-coordinate.
    getter x
    # Returns the y-coordinate.
    getter y

    # Returns whether or not the three given points are collinear, i.e. whether a straight line could be drawn that passes through all three points.
    def self.collinear?(p1 : Point, p2 : Point, p3 : Point)
      num = ((p1.x * (p2.y - p3.y)) +
             (p2.x * (p3.y - p1.y)) +
             (p3.x * (p1.y - p2.y)))

      -0.01 <= num && num <= 0.01 # precision limit
    end

    # Creates a new `Point`.
    def initialize(@x : Number::Primitive = 0, @y : Number::Primitive = 0)
    end

    def_equals_and_hash(to_a)

    # Separately yields the x- and y-coordinates of the point.
    def each
      yield @x
      yield @y
    end

    # Returns a string representation of the point in the form `(x, y)`.
    def to_s
      sprintf("(%g, %g)", @x, @y)
    end
  end
end
