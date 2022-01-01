require "./spec_helper"

describe Dorsum::AnsiColor do
  describe "no color" do
    it "parses" do
      Dorsum::AnsiColor.new(nil).ansi_code.should eq 255
    end
  end

  describe "simple color" do
    it "parses" do
      Dorsum::AnsiColor.new("#FF0000").ansi_code.should eq 196
    end
  end

  describe "color" do
    it "parses" do
      Dorsum::AnsiColor.new("#E813A7").ansi_code.should eq 185
    end
  end
end
