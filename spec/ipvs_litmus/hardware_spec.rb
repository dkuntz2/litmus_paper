require 'spec_helper'

describe IPVSLitmus::Hardware do
  describe "#processor_count" do
    it "is a positive integer" do
      IPVSLitmus::Hardware.new.processor_count.should > 0
    end
  end

  describe "#memory_total" do
    it "is a positive integer" do
      IPVSLitmus::Hardware.new.memory_total.should > 1_000.0
    end
  end

  describe "#memory_free" do
    it "is a positive integer" do
      IPVSLitmus::Hardware.new.memory_free.should > 100
    end
  end

  describe "load" do
    it "is a floating point" do
      IPVSLitmus::Hardware.new.load.should > 0.0
    end
  end
end