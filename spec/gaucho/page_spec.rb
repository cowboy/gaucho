require 'gaucho'
require 'pp'

module Gaucho
  describe Page do
    before do
      @pageset = Pageset.new 'spec/fixtures/basic'
      @page = Page.new 'page-1', @pageset
    end

    describe "#id" do
      it "should reflect the passed-in id" do
        page = Page.new 'SAMPLE', nil
        page.id.should eq 'SAMPLE'
      end
    end

    describe "#pageset" do
      it "should reflect the passed-in pageset" do
        @page.pageset.should eq @pageset
      end
    end

    describe "#commits" do
      it "should contain a list of Gaucho::Commit objects" do
        @page.commits.all? {|c| c.instance_of? Gaucho::Commit}.should eq true
      end
    end
  end
end