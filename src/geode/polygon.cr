require './circle'
require './line'

module Geode
  class Polygon
    getter vertices
    @vertices : Array(Point)

    # we input vertices and calculate lines later so we can make them automatically connect to one another
    def initialize(*vertices : Point)
      # you can't really type restrict Tuples of variadic length (which is how splat arguments get input)
      # because of this, we store them internally as an array
      @vertices = vertices.to_a
    end

    # overloading to accept arrays as well as tuples
    def initialize(@vertices : Array(Point))
    end

    def area
      0.5 * segments.reduce(0) do |sum, seg|
        sum + ((seg.p1.x * seg.p2.y) - (seg.p2.x * segment.p1.y))
      end.abs
    end

    # TODO: Polygon#contains?
    
    def include?(other : Point)
      segments.any?(&.include?(other))
    end

    def perimeter
      segments.reduce(0) {|sum, seg| sum + seg.length}
    end

    def segments
      # the array created is in the form [[p1, p2], [p2, p3],..., [p(n-1), p(n)], [p(n), p1]]
      @vertices.zip(@vertices.rotate).map {|s| Segment.new(*s)}
    end
  end

  class RegularPolygon < Polygon
    getter circumcircle

    def initialize(sides : Int, @circumcircle : Circle = Circle.new, rotation : Angle = Angle.new(0))
      raise ArgumentError.new("amount of sides must be > 2") unless sides > 2

      super(sides.times.map {|i| circumcircle.to_point(Angle.new((2 * Math::PI * i) / sides) + rotation)}.to_a)
    end
  end
end
