require 'gaucho'

module Gaucho
  describe Metadata do
    describe "#to_hash" do
      it "should reflect the underlying hash" do
        hash = {a: 123}
        meta = Gaucho::Metadata.new hash
        meta.to_hash.should eq hash
      end
    end

    describe "#[]" do
      it "should access the underlying hash properties" do
        hash = {a: 123}
        meta = Gaucho::Metadata.new hash
        meta[:a].should eq hash[:a]
      end
      it "should be case insensitive" do
        meta = Gaucho::Metadata.new TeSt: 123
        meta[:tEsT].should eq 123
      end
    end

    describe "#[]=" do
      it "should set the underlying hash properties" do
        meta = Gaucho::Metadata.new
        meta[:a] = 123
        meta[:a].should eq 123
      end
      it "should work recursively" do
        meta = Gaucho::Metadata.new
        meta[:a] = {b: 1}
        meta[:a][:b].should eq 1
        meta[:a].instance_of?(Gaucho::Metadata).should eq true
      end
    end

    describe "#[arbitrary property]" do
      it "should work" do
        meta = Gaucho::Metadata.new a: 123
        meta.a.should eq 123
      end
      it "should work recursively" do
        meta = Gaucho::Metadata.new a: {b: 1}
        meta.a.b.should eq 1
      end
      it "should be case insensitive" do
        meta = Gaucho::Metadata.new TeSt: 123
        meta.tEsT.should eq 123
      end
      it "should allow setting" do
        meta = Gaucho::Metadata.new
        meta.a = 123
        meta.a.should eq 123
      end
      it "should allow setting recursively" do
        meta = Gaucho::Metadata.new
        meta.a = {b: 1}
        meta.a.b.should eq 1
      end
    end
  end
end
