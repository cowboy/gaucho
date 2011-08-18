require 'gaucho/pageset'
require 'pp'

module Gaucho
  describe Pageset do
    describe "basic tests:" do
      before do
        @pageset = Pageset.new 'spec/fixtures/basic-tests'
      end

      it "#repo: should be a Grit::Repo" do
        # passing in a path
        @pageset.repo.should.instance_of? Grit::Repo
        # passing in a Grit::Repo instance
        repo = Grit::Repo.new 'spec/fixtures/basic-tests'
        pageset = Pageset.new repo
        pageset.repo.should.instance_of? Grit::Repo
      end

      it "#page_commits: should parse the commit log properly" do
        # note: this is overly implementation-specific
        @pageset.page_commits.all? do |id, commits|
          id =~ /^page-\d+$/ &&
            commits.count == 2 &&
            commits.first[:files].count == 1 &&
            commits.last[:files].count == 2
        end.should == true
      end

      it "#[]: should allow access to pages by their id" do
        @pageset['page-1'].instance_of? Gaucho::Page
        @pageset['page-99'].instance_of? Gaucho::Page
      end

      it "#pages: should allow access to all pages" do
        @pageset.pages.count.should == 10
        @pageset.pages.all? {|page| page.instance_of? Gaucho::Page}.should == true
      end

      it "#each (etc): should behave like an Enumerable" do
        # Enumeration w/ block
        @pageset.inject(0) {|sum, page| sum += 1}.should == 10
        # Enumerator w/o block
        @pageset.each.inject(0) {|sum, page| sum += 1}.should == 10
        # Etc
        @pageset.count.should == 10
        @pageset.first.should.instance_of? Gaucho::Page
        @pageset.all? {|page| page.instance_of? Gaucho::Page}.should == true
      end


    end
  end
end
