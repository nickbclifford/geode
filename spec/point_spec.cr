require "./spec_helper"

include Geode

describe Point do
  point = Point.new(-5, 6)

  it "is Enumerable" do
    point.map(&.-(1)).should eq [-6, 5]
  end

  it "can detect whether three points are collinear" do
    Point.collinear?(point, Point.new, Point.new(2.5, -3)).should be_true
  end

  it "can be converted into its equation" do
    point.to_s.should eq "(-5, 6)"
  end
end
