require 'gaucho'
require 'pp'

module Gaucho
  describe Commit do
    before do
      @pageset = Pageset.new 'spec/fixtures/basic'
      @page = Page.new 'page-1', @pageset

      # Easiest way to get a valid commit SHA for this pageset.
      @id = @page.commits.last.id
      @commit = Gaucho::Commit.new @id, @page
    end

    describe "#id" do
      it "should reflect the passed-in id" do
        commit = Gaucho::Commit.new @id, @page
        commit.id.should eq @id
      end
    end

    describe "#commit" do
      it "should be a Grit::Commit object" do
        @commit.commit.instance_of?(Grit::Commit).should eq true
      end

      it "should be the correct Grit::Commit object" do
        @commit.commit.to_hash.should eq({
          "id"=>"56dfc6a4205432dfaba127fcbe1ae146c49d3748",
          "parents"=>[{"id"=>"a018c1844455aa6ee9d8b48fc6826e7d70963d74"}],
          "tree"=>"b15fe84ffee91f70cd2616cdacb4da9a9bae08ce",
          "message"=>"Updated page 1.",
          "author"=>{"name"=>"Ben Alman", "email"=>"cowboy@rj3.net"},
          "committer"=>{"name"=>"Ben Alman", "email"=>"cowboy@rj3.net"},
          "authored_date"=>"2000-01-03T09:00:00-08:00",
          "committed_date"=>"2000-01-04T09:00:00-08:00"
        })
      end
    end

    %w{id parents tree message author committer authored_date committed_date}.each do |method|
      describe "##{method}" do
        it "should foward to the underlying Grit::Commit object" do
          @commit.public_send(method.to_sym).should eq @commit.commit.public_send(method.to_sym)
        end
      end
    end

    describe "#meta" do
      it "should reflect the commit's page metadata" do
        #pp @commit.meta
      end
    end
  end
end
