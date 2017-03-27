require "./angle"

module Geode
  class Circle
    getter radius
    getter center

    def initialize(radius : Number::Primitive = 1, @center : Point = Point.new)
      raise ArgumentError.new("radius must be > 0") unless radius > 0
      @radius = radius
    end

    def_equals_and_hash(radius, center)

    # length methods

    def circumference
      2 * Math::PI * @radius
    end

    def arc_length(angle : Angle)
      @radius * angle.radians
    end

    def include?(other : Point)
      Math.hypot(other.x, other.y) == @radius
    end

    # area methods

    def sector_area(angle : Angle)
      0.5 * (@radius ** 2) * angle.radians
    end

    def area
      Math::PI * (@radius ** 2)
    end

    def contains?(other : Point)
      Math.hypot(other.x, other.y) <= @radius
    end

    # misc methods
    
    def to_point(angle : Angle)
      angle.to_point(@radius, @center)
    end

    def to_s
      sprintf("(x-%g)^2 + (y-%g)^2 = %g", @center.x, @center.y, @radius ** 2)
    end
  end
end
