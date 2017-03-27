require "./point"

module Geode
  class Angle
    include Comparable(Number)

    def initialize(measure : Number::Primitive, unit : Symbol = :radians)
      if unit == :radians
        @measure = measure
      elsif unit == :degrees
        @measure = measure * (Math::PI / 180)
      else
        raise ArgumentError.new("angle unit not recognized (must be :radians or :degrees)")
      end
    end

    def <=>(other : Angle)
      @measure <=> other.radians
    end

    def +(other : Angle)
      Angle.new(@measure + other.radians)
    end

    def -(other : Angle)
      Angle.new(@measure - other.radians)
    end

    def *(other : Number)
      Angle.new(@measure * other)
    end

    def /(other : Number)
      Angle.new(@measure / other)
    end

    def radians
      @measure
    end

    def degrees
      @measure * (180 / Math::PI)
    end

    def boundary?
      @measure % (Math::PI / 2) == 0
    end

    def half?
      @measure % Math::PI == 0
    end

    def full?
      @measure % (2 * Math::PI) == 0
    end

    def quadrant
      return nil if boundary?

      (normalize.degrees / 90).to_i + 1
    end

    def reference
      return Angle.new(0) if half?

      case quadrant
      when nil
        Angle.new(Math::PI / 2)
      when 1
        Angle.new(@measure)
      when 2
        Angle.new(Math::PI - @measure)
      when 3
        Angle.new(@measure - Math::PI)
      when 4
        Angle.new((2 * Math::PI) - @measure)
      end
    end

    def normalize
      Angle.new(@measure % (2 * Math::PI))
    end

    def to_point(distance : Number = 1, center : Point = Point.new)
      Point.new((distance * cos) + center.x, (distance * sin) + center.y)
    end

    macro finished
      {% for fn, inv in {"sin" => "csc", "cos" => "sec", "tan" => "cot"} %}
        def {{fn.id}}
          Math.{{fn.id}}(@measure)
        end

        def {{inv.id}}
          1 / {{fn.id}}
        end
      {% end %}
    end
  end
end
