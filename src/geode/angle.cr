require "./point"

module Geode
  # The `Angle` class represents a geometric angle.
  # Basic arithmetic as well as trigonometric functions can be applied to it.
  class Angle
    include Comparable(Number)

    # Creates a new `Angle`.
    def initialize(measure : Number::Primitive, unit : Symbol = :radians)
      if unit == :radians
        @measure = measure
      elsif unit == :degrees
        @measure = measure * (Math::PI / 180)
      else
        raise ArgumentError.new("angle unit not recognized (must be :radians or :degrees)")
      end
    end

    # Compares the measures of two angles.
    def <=>(other : Angle)
      @measure <=> other.radians
    end

    # Adds the measures of two angles.
    def +(other : Angle)
      Angle.new(@measure + other.radians)
    end

    # Subtracts the measure of one angle from another angle.
    def -(other : Angle)
      Angle.new(@measure - other.radians)
    end

    # Multiplies an angle's measure by the given scalar.
    def *(other : Number)
      Angle.new(@measure * other)
    end

    # Divides an angle's measure by the given scalar.
    def /(other : Number)
      Angle.new(@measure / other)
    end

    # Returns the angle's measure in radians.
    def radians
      @measure
    end

    # Returns the angle's measure in degrees.
    def degrees
      @measure * (180 / Math::PI)
    end

    # Returns whether or not the given angle lines on a quadrant boundary, i.e. whether the angle's measure is divisible by 1/2pi / 90 degrees.
    def boundary?
      @measure % (Math::PI / 2) == 0
    end

    # Returns whether or not the given angle represents a semi-circle, i.e. whether the angle's measure is divisible by pi / 180 degrees.
    def half?
      @measure % Math::PI == 0
    end

    # Returns whether or not the given angle represents a full circle, i.e. whether the angle's measure is divisible by 2pi / 360 degrees.
    def full?
      @measure % (2 * Math::PI) == 0
    end

    # Returns which quadrant the angle lies in. If the angle lies on a quadrant boundary, it returns nil.
    def quadrant
      return nil if boundary?

      (normalize.degrees / 90).to_i + 1
    end

    # Returns the reference angle, i.e. the smallest angle that the terminal side makes with the x-axis.
    def reference
      return Angle.new(0) if half?

      Angle.new(
        case quadrant
        when nil
          Math::PI / 2
        when 1
          @measure
        when 2
          Math::PI - @measure
        when 3
          @measure - Math::PI
        when 4
          (2 * Math::PI) - @measure
        end
      )
    end

    # Returns a new `Angle` with the measure restricted to the interval [0, 2pi) / [0, 360).
    def normalize
      Angle.new(@measure % (2 * Math::PI))
    end

    # Returns the `Point` that lies `distance` units away from the terminal side centered at `center`.
    def to_point(distance : Number = 1, center : Point = Point.new)
      Point.new((distance * cos) + center.x, (distance * sin) + center.y)
    end

    macro finished
      {% names = {
        "sin" => "sine",
        "cos" => "cosine",
        "tan" => "tangent",
        "sec" => "secant",
        "csc" => "cosecant",
        "cot" => "cotangent"
      } %}
      {% for fn, inv in {"sin" => "csc", "cos" => "sec", "tan" => "cot"} %}
        # Returns the {{names[fn].id}} function of the angle.
        def {{fn.id}}
          Math.{{fn.id}}(@measure)
        end

        # Returns the {{names[inv].id}} function (inverse {{names[fn].id}}) of the angle.
        def {{inv.id}}
          1 / {{fn.id}}
        end
      {% end %}
    end
  end
end
