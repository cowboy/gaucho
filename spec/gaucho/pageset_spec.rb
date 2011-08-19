require 'gaucho/pageset'
require 'pp'

module Gaucho
  describe Pageset do
    describe "basic tests:" do
      before do
        @pageset = Pageset.new 'spec/fixtures/basic-tests'
      end

      describe "#repo" do
        it "should be a Grit::Repo (passing in a path)" do
          @pageset.repo.instance_of?(Grit::Repo).should eq true
        end
        it "should be a Grit::Repo (passing in a repo)" do
          repo = Grit::Repo.new 'spec/fixtures/basic-tests'
          pageset = Pageset.new repo
          pageset.repo.instance_of?(Grit::Repo).should eq true
        end
      end

      describe "#page_commits" do
        it "should parse the commit log properly" do
          # note: this is overly implementation-specific
          @pageset.page_commits.all? do |id, commits|
            id =~ /^page-\d+$/ &&
              commits.count == 2 &&
              commits.first[:files].count == 1 &&
              commits.last[:files].count == 2
          end.should eq true
        end
      end

      describe "#[]" do
        it "should allow access to pages by their id" do
          @pageset['page-1'].instance_of?(Gaucho::Page).should eq true
          @pageset['nonexistent'].should eq nil
        end
      end

      describe "#pages" do
        it "should allow access to all pages" do
          @pageset.pages.count.should eq 10
          @pageset.pages.all? {|page| page.instance_of? Gaucho::Page}.should eq true
        end
      end

      it "should behave like an Enumerable" do
        # Enumeration w/ block
        @pageset.inject(0) {|sum, page| sum += 1}.should eq 10
        # Enumerator w/o block
        @pageset.each.inject(0) {|sum, page| sum += 1}.should eq 10
        # Etc
        @pageset.count.should eq 10
        @pageset.first.instance_of?(Gaucho::Page).should eq true
        @pageset.all? {|page| page.instance_of? Gaucho::Page}.should eq true
      end

      it "should default to sorting by commit date"

    end
  end
end
