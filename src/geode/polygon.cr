require "./circle"
require "./line"

module Geode
  # The `Polygon` class represents a polygon, i.e. numerous vertices connected by lines.
  class Polygon
    # Returns all the vertices of the polygon.
    getter vertices
    @vertices : Array(Point)

    # Creates a new `Polygon` with variadic arguments.
    def initialize(*vertices : Point)
      # you can't really type restrict Tuples of variadic length (which is how splat arguments get input for some reason)
      # because of this, we store them internally as an array
      @vertices = vertices.to_a
    end

    # Creates a new `Polygon` instance with an array of vertices.
    def initialize(@vertices : Array(Point))
    end

    # Returns the area of a polygon.
    def area
      0.5 * segments.reduce(0) do |sum, seg|
        sum + ((seg.p1.x * seg.p2.y) - (seg.p2.x * seg.p1.y))
      end.abs
    end

    # TODO: Polygon#contains?

    # Returns whether the given point lies on the polygon's perimeter.
    def include?(other : Point)
      segments.any?(&.include?(other))
    end

    # Returns the total perimeter of the polygon.
    def perimeter
      segments.reduce(0) { |sum, seg| sum + seg.length }
    end

    # Returns an array of the line segments that make up the polygon.
    # The created array is in the form `[Segment.new(p1, p2), Segment.new(p2, p3), ..., Segment.new(p(n-1), p(n)), Segment.new(p(n), p1)]`.
    def segments
      @vertices.zip(@vertices.rotate).map { |s| Segment.new(*s) }
    end
  end

  # The `RegularPolygon` class represents a polygon with sides of constant length separated by angles of constant measure.
  class RegularPolygon < Polygon
    # Returns the circumcircle of the polygon, i.e. the circle that wholly surrounds the polygon and all its vertices.
    getter circumcircle

    # Creates a new `RegularPolygon`.
    def initialize(sides : Int, @circumcircle : Circle = Circle.new, rotation : Angle = Angle.new(0))
      raise ArgumentError.new("amount of sides must be > 2") unless sides > 2

      super(sides.times.map { |i| circumcircle.to_point(Angle.new((2 * Math::PI * i) / sides) + rotation) }.to_a)
    end
  end
end
