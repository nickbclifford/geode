require "./point"

module Geode
  # The `Line` class represents a two-dimensional line with **no defined endpoints**.
  # For a line with endpoints, see the `Segment` class.
  class Line
    # Returns the slope of the line.
    getter slope

    # Returns whether the two given lines are perpendicular to each other.
    def self.perpendicular?(l1 : Line, l2 : Line)
      l1.slope == 0 - (1.0 / l2.slope) # really, Crystal? no unary '-' negation operator?
    end

    # Creates a new `Line`.
    def initialize(@slope : Number::Primitive, @intercept_val : Number::Primitive)
    end

    def_equals_and_hash(slope, y_intercept)

    # Returns whether the line is horizontal.
    def horizontal?
      slope == 0
    end

    # Returns whether the given point lies on the line.
    def include?(other : Point)
      return other.x == x_intercept.as(Point).x if vertical?
      other.y == (slope * other.x) + y_intercept.as(Point).y
    end

    # Returns a string representation of the line in slope-intercept form (`y = mx + b`).
    # A vertical line will return a string in the form `x = c` where `c` is the line's x-intercept.
    def to_s
      if vertical?
        sprintf("x = %g", x_intercept.as(Point).x)
      elsif horizontal?
        sprintf("y = %g", y_intercept.as(Point).y)
      else
        sprintf("y = %gx + %g", slope, y_intercept.as(Point).y)
      end
    end

    # Returns whether the line is vertical.
    def vertical?
      slope.to_f.infinite?
    end

    # Returns the x-intercept of the line. If the line is horizontal, it has no x-intercept, so it returns `nil`.
    def x_intercept
      return nil if horizontal?

      Point.new(vertical? ? @intercept_val : 0 - (y_intercept.as(Point).y / slope), 0)
    end

    # Returns the y-intercept of the line. If the line is vertical, it has no y-intercept, so it returns `nil`.
    def y_intercept
      return nil if vertical?

      Point.new(0, @intercept_val)
    end
  end

  # The `Segment` class represents a two-dimensional line segment with two endpoints.
  class Segment < Line
    # Returns the first endpoint of the segment.
    getter p1
    # Returns the second endpoint of the segment.
    getter p2

    include Enumerable(Point)

    def initialize(@p1 : Point, @p2 : Point)
    end

    def_equals_and_hash(p1, p2)

    # Separately yields the two endpoints of the segment.
    def each
      yield @p1
      yield @p2
    end

    # Returns whether the given point lies on the segment.
    def include?(other : Point)
      # if the point isn't on the line, there's no chance of it being in the segment
      return false unless to_line.include?(other)

      minmax_x = map(&.x).minmax
      minmax_y = map(&.y).minmax

      if vertical?
        other.x == x_intercept.x && minmax_y[0] <= other.y && other.y <= minmax_y[1]
      else
        minmax_x[0] <= other.x && other.x <= minmax_x[1] && minmax_y[0] <= other.y && other.y <= minmax_y[1]
      end
    end

    # Returns the length of the segment.
    def length
      Math.hypot(@p1.x - @p2.x, @p1.y - @p2.y)
    end

    # Returns the midpoint of the segment.
    def midpoint
      Point.new((@p1.x + @p2.x).to_f / 2, (@p1.y + @p2.y).to_f / 2)
    end

    # Returns the slope of the segment.
    def slope
      (@p1.y - @p2.y) / (@p1.x - @p2.x)
    end

    # Returns a `Line` representation of the segment.
    def to_line
      Line.new(slope, vertical? ? x_intercept.as(Point).x : y_intercept.as(Point).y)
    end

    # you shouldn't have to use the x- and y-intercept methods when dealing with segments
    # they're private instead of being removed since Line#to_s needs them for proper function
    private def x_intercept
      return nil if horizontal?

      Point.new(vertical? ? @p1.x : 0 - (y_intercept.as(Point).y / slope), 0)
    end

    private def y_intercept
      return nil if vertical?

      Point.new(0, @p1.y - (slope * @p1.x))
    end
  end
end
