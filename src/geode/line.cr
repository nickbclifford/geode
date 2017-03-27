require './point'

module Geode
  class Line
    # README: the way we do the slope instance variable is slightly different in here versus other classes
    # because Segment has a custom #slope method, we have to access @slope in Line with the getter below
    getter slope

    # @intercept_val should never be accessed except in #x_intercept and #y_intercept
    # *technically*, it doesn't matter, but please use those methods instead for readability's sake
    def initialize(@slope : Float64, @intercept_val : Float64)
    end

    def_equals_and_hash(slope, y_intercept)

    def horizontal?
      slope == 0
    end

    def include?(other : Point)
      return other.x == x_intercept.as(Point).x if vertical?
      other.y == (slope * other.x) + y_intercept.as(Point).y
    end

    def perpendicular?(other : Line)
      other.slope == -(1 / slope)
    end

    def to_s
      if vertical?
        sprintf("x = %g", x_intercept.as(Point).x)
      elsif horizontal?
        sprintf("y = %g", y_intercept.as(Point).y)
      else
        sprintf("y = %gx + %g", slope, y_intercept.as(Point).y)
      end        
    end

    def vertical?
      slope.infinite?
    end

    def x_intercept
      return nil if horizontal?

      Point.new(vertical? ? @intercept_val : -(y_intercept.as(Point).y / slope), 0.0)
    end

    def y_intercept
      return nil if vertical?

      Point.new(0.0, @intercept_val)
    end
  end

  class Segment < Line
    include Enumerable(Float64)

    def initialize(@p1 : Point, @p2 : Point)
    end

    def ==(other : Segment)
      @p1 == other.p1 && @p2 == other.p2
    end

    def each
      yield @p1
      yield @p2
    end

    def include?(other)
      # if the point isn't on the line, there's no chance of it being in the segment
      return false unless to_line.include?(other)

      minmax_x = map(&:x).minmax
      minmax_y = map(&:y).minmax

      if vertical?
        other.x == x_intercept.x && minmax_y[0] <= other.y && other.y <= minmax_y[1]
      else
        minmax_x[0] <= other.x && other.x <= minmax_x[1] && minmax_y[0] <= other.y && other.y <= minmax_y[1]
      end
    end

    def length
      Math.hypot(@p1.x - @p2.x, @p1.y - @p2.y)
    end

    def midpoint
      Point.new((@p1.x + @p2.x).to_f / 2, (@p1.y + @p2.y).to_f / 2)
    end

    def slope
      (@p1.y - @p2.y) / (@p1.x - @p2.x)
    end

    def to_line
      Line.new(slope, vertical? ? x_intercept.as(Point).x : y_intercept.as(Point).y)
    end

    # you shouldn't have to use the x- and y-intercept methods when dealing with segments
    # they're private instead of being removed since Line#to_s needs them for proper function
    private def x_intercept
      return nil if horizontal?

      Point.new(vertical? ? @p1.x : -(y_intercept.as(Point).y / slope), 0.0)
    end

    private def y_intercept
      return nil if vertical?

      Point.new(0.0, @p1.y - (slope * @p1.x))
    end
  end
end
