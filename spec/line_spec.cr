require "./spec_helper"

include Geode

point = Point.new(1, 2)
line = Line.new(3, -1)

describe Line do
  horiz = Line.new(0, 3)
  vert = Line.new(Float64::INFINITY, 4)

  it "can detect whether two lines are perpendicular" do
    Line.perpendicular?(line, Line.new(0, 0)).should be_false
    Line.perpendicular?(line, Line.new(-(1 / 3.0), 2)).should be_true
  end

  it "can detect the orientation of a line" do
    vert.vertical?.should be_true
    horiz.horizontal?.should be_true
    line.horizontal?.should be_false
  end

  it "can detect whether a point lies on the line" do
    line.include?(point).should be_true
    line.include?(Point.new).should be_false
  end

  it "can be converted into its equation" do
    vert.to_s.should eq "x = 4"
    horiz.to_s.should eq "y = 3"
    line.to_s.should eq "y = 3x + -1"
  end

  it "can return x and y intercepts" do
    line.y_intercept.as(Point).y.should eq -1
    line.x_intercept.as(Point).x.should eq (1 / 3.0)
  end
end

describe Segment do
  seg = Segment.new(Point.new(0, -1), Point.new(2, 5))

  it "is Enumerable" do
    seg.map(&.to_s).should eq ["(0, -1)", "(2, 5)"]
  end

  it "can detect whether a point lies on the segment" do
    seg.include?(point).should be_true
    seg.include?(Point.new).should be_false
  end

  it "can return its length" do
    seg.length.should eq 2 * Math.sqrt(10)
  end

  it "can return its slope and midpoint" do
    seg.slope.should eq 3
    seg.midpoint.should eq Point.new(1, 2)
  end

  it "can become a Line" do
    seg.to_line.should eq line
  end
end
