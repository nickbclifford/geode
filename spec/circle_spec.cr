require "./spec_helper"

include Geode

describe Geode do
  describe Circle do
    circ = Circle.new(5)

    it "can calculate circumference and area" do
      circ.circumference.should eq 10 * Math::PI
      circ.area.should eq 25 * Math::PI
    end

    it "can calculate arc length and sector area (defined by an angle)" do
      theta = Angle.new(45, :degrees)
      circ.arc_length(theta).should eq 5 * (Math::PI / 4)
      circ.sector_area(theta).should eq 25 * (Math::PI / 8)
    end

    it "can detect whether a point is inside or on the circumference" do
      point = Point.new
      circ.include?(point).should be_false
      circ.contains?(point).should be_true
    end

    # http://i.imgur.com/nXfES1K.png
    # it "can calculate the point on the circumference at a certain angle" do
    #   circ.to_point(Angle.new(60, :degrees)).should eq Point.new(2.5, 5 * (Math.sqrt(3) / 2))
    # end
    it "can be converted into its equation" do
      circ.to_s.should eq "(x-0)^2 + (y-0)^2 = 25"
    end
  end
end
