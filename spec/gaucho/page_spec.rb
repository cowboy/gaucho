require 'gaucho'
require 'pp'

module Gaucho
  describe Page do
    before do
    end
    describe "#id" do
      it "should reflect the correct page id" do
        @page = Page.new 'sample-page', %w{aaaaaaaa bbbbbbbb}
        @page.id.should eq 'sample-page'
      end
    end
  end
end