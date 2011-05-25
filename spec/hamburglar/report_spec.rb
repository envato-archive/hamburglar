require 'spec_helper'

describe Hamburglar::Report do
  describe "#initialize" do
    it "sets @params" do
      r = Hamburglar::Report.new(:foo => :bar)
      p = r.instance_variable_get(:@params)
      p.should be_a Hash
      p.should have_key :foo
    end
  end
end
