require 'gaucho'
require 'pp'

module Gaucho
  describe Pageset do
    describe "basic tests:" do
      before do
        @pageset = Pageset.new 'spec/fixtures/basic'
      end

      describe "#repo" do
        it "should be a Grit::Repo (passing in a path)" do
          @pageset.repo.instance_of?(Grit::Repo).should eq true
        end
        it "should be a Grit::Repo (passing in a repo)" do
          repo = Grit::Repo.new 'spec/fixtures/basic'
          pageset = Pageset.new repo
          pageset.repo.instance_of?(Grit::Repo).should eq true
        end
      end

      describe "#subdir" do
        it "should be nil by default" do
          pageset = Pageset.new 'spec/fixtures/subdir'
          pageset.subdir.should eq nil
        end
        it "should reflect the passed subdir option" do
          pageset = Pageset.new 'spec/fixtures/subdir', subdir: 'foo/'
          pageset.subdir.should eq 'foo/'
        end
        it "should have a trailing /" do
          pageset = Pageset.new 'spec/fixtures/subdir', subdir: 'foo'
          pageset.subdir.should eq 'foo/'
        end
      end

      describe "#page_commits" do
        # note: this is overly implementation-specific
        def make_test(page_id_regex)
          Proc.new do |id, commits|
            id =~ page_id_regex &&
              commits.count == 2 &&
              commits.first[:files].count == 1 &&
              commits.last[:files].count == 2
          end
        end
        it "should parse the commit log properly" do
          @pageset.page_commits.all?(&make_test(/^page-\d$/)).should eq true
        end
        it "should parse the commit log properly when subdir is used" do
          %w{foo bar}.each do |subdir|
            pageset = Pageset.new 'spec/fixtures/subdir', subdir: subdir
            pageset.page_commits.all?(&make_test(/^#{subdir}-page-\d$/)).should eq true
          end
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
          @pageset.pages.count.should eq 3
          @pageset.pages.all? {|page| page.instance_of? Gaucho::Page}.should eq true
        end
      end

      it "should behave like an Enumerable" do
        # Enumeration w/ block
        @pageset.inject(0) {|sum, page| sum += 1}.should eq 3
        # Enumerator w/o block
        @pageset.each.inject(0) {|sum, page| sum += 1}.should eq 3
        # Etc
        @pageset.count.should eq 3
        @pageset.first.instance_of?(Gaucho::Page).should eq true
        @pageset.all? {|page| page.instance_of? Gaucho::Page}.should eq true
      end

      #it "should default to sorting by commit date"

    end
  end
end
