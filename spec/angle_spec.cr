require "./spec_helper"

include Geode

describe Geode do
  describe Angle do
    it "is Comparable" do
      Angle.new(Math::PI).should be > Angle.new(Math::PI / 2)
    end

    it "can accept degrees and radians" do
      Angle.new(Math::PI).should eq Angle.new(180, :degrees)
    end

    it "can use basic arithmetic" do
      (Angle.new(Math::PI / 4) + Angle.new(Math::PI / 2)).should eq Angle.new(135, :degrees)
      (Angle.new(Math::PI) - Angle.new(Math::PI / 2)).should eq Angle.new(90, :degrees)
      (Angle.new(30, :degrees) * 3).should eq Angle.new(90, :degrees)
      (Angle.new(60, :degrees) / 2).should eq Angle.new(30, :degrees)
    end

    it "can convert between degrees and radians" do
      Angle.new(180, :degrees).radians.should eq Math::PI
      Angle.new(Math::PI / 2).degrees.should eq 90
    end

    it "can detect quadrant boundaries" do
      Angle.new(90, :degrees).boundary?.should be_true
    end

    it "can detect half and full circles" do
      Angle.new(Math::PI).half?.should be_true
      Angle.new(Math::PI / 2).half?.should be_false
      Angle.new(2 * Math::PI).full?.should be_true
      Angle.new(3 * Math::PI).full?.should be_false
    end

    it "can determine what quadrant the terminal side is in" do
      Angle.new(135, :degrees).quadrant.should eq 2
      Angle.new(90, :degrees).quadrant.should be_nil
    end

    it "can determine the reference angle" do
      Angle.new(135, :degrees).reference.should eq Angle.new(45, :degrees)
    end

    it "can normalize" do
      Angle.new(-50, :degrees).normalize.should eq Angle.new(310, :degrees)
    end

    # FIXME: there seems to be a slight rounding error with this, but only at 15 digits or something
    # it "can find the point at a certain distance on the terminal side" do
    #   Angle.new(45, :degrees).to_point.should eq Point.new(Math.sqrt(2) / 2, Math.sqrt(2) / 2)
    # end
    it "can use basic trigonometric functions" do
      Angle.new(60, :degrees).sin.should eq Math.sqrt(3) / 2
      Angle.new(180, :degrees).cos.should eq -1
      Angle.new(30, :degrees).tan.should eq Math.sqrt(3) / 3
      Angle.new(90, :degrees).csc.should eq 1
      Angle.new(135, :degrees).sec.should eq -Math.sqrt(2)
      # http://i.imgur.com/b5FQlSO.png
      # Angle.new(45, :degrees).cot.should eq 1.0
    end
  end
end
