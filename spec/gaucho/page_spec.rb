require 'gaucho'
require 'pp'

module Gaucho
  describe Page do
    before do
      @pageset = Pageset.new 'spec/fixtures/basic'
    end
    describe "#id" do
      it "should reflect the passed-in id" do
        page = Page.new 'sample-page', nil
        page.id.should eq 'sample-page'
      end
    end
    describe "#pageset" do
      it "should reflect the passed-in pageset" do
        page = Page.new 'sample-page', @pageset
        page.pageset.should eq @pageset
      end
    end
  end
end