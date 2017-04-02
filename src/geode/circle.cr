require "./angle"

module Geode
  # The `Circle` struct represents a circle.
  struct Circle
    # Returns the radius of the circle.
    getter radius
    # Returns the center of the circle.
    getter center

    # Creates a new `Circle`. Note that the radius must be positive.
    def initialize(radius : Number::Primitive = 1, @center : Point = Point.new)
      raise ArgumentError.new("radius must be > 0") unless radius > 0
      @radius = radius
    end

    def_equals_and_hash(radius, center)

    # length methods

    # Returns the circumference of the circle.
    def circumference
      2 * Math::PI * @radius
    end

    # Returns the length along the circle's circumference of the arc defined by the given angle.
    def arc_length(angle : Angle)
      @radius * angle.radians
    end

    # Returns whether the given point lies on the circumference of the circle.
    def include?(other : Point)
      Math.hypot(other.x, other.y) == @radius
    end

    # area methods

    # Returns the area of the sector of the circle defined by the given angle.
    def sector_area(angle : Angle)
      0.5 * (@radius ** 2) * angle.radians
    end

    # Returns the area of the circle.
    def area
      Math::PI * (@radius ** 2)
    end

    # Returns whether the given point lies on *or inside* the circle's circumference.
    def contains?(other : Point)
      Math.hypot(other.x, other.y) <= @radius
    end

    # Returns the `Point` along the circle's circumference that corresponds to the given angle.
    def to_point(angle : Angle)
      angle.to_point(@radius, @center)
    end

    # Returns a string representation of the circle in the form `(x-h)^2 + (y-k)^2 = r`, where (h, k) is the circle's circumference and `r` is the circle's radius squared.
    def to_s(io : IO)
      io << "(x-#{@center.x})^2 + (y-#{@center.y})^2 = #{@radius ** 2}"
    end
  end
end
