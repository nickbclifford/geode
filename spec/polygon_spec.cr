require "./spec_helper"

include Geode

poly = Polygon.new(p1 = Point.new, p2 = Point.new(1, 4), p3 = Point.new(5), p4 = Point.new(3, -6))

describe Polygon do
  it "can calculate its area and perimeter" do
    poly.area.should eq 25
    poly.perimeter.should eq (4 * Math.sqrt(2)) + (3 * Math.sqrt(5)) + (2 * Math.sqrt(10)) + Math.sqrt(17)
  end

  it "can detect whether a point lies on its perimeter" do
    poly.include?(Point.new(3, 2)).should be_true
    poly.include?(Point.new(1)).should be_false
  end

  it "can break apart into its component segments" do
    poly.segments.should eq [Segment.new(p1, p2), Segment.new(p2, p3), Segment.new(p3, p4), Segment.new(p4, p1)]
  end
end

describe RegularPolygon do
  it "can create a regular n-gon" do
    RegularPolygon.new(4).vertices.map {|p| p.map(&.round)}.should eq [[1, 0], [0, 1], [-1, 0], [0, -1]] # Because rounding errors and really small numbers.
  end
end
