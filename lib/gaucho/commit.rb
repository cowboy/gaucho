
module Gaucho
  class Commit
    extend Forwardable

    attr_reader :commit, :page

    # Forward Grit::Commit methods to :commit.
    def_delegators :commit, :id, :parents, :message, :author, :committer,
      :authored_date, :committed_date

    def initialize(commit_id, page)
      @page = page
      @commit = @page.pageset.repo.commit commit_id
    end

    # Grit::Tree for this page at this commit.
    def tree
      if page.pageset.subdir.nil?
        commit.tree/page.id
      else
        commit.tree/page.pageset.subdir/page.id
      end
    end

    # Metadata for this commit's page index.md file.
    def meta
      return @meta unless @meta.nil?
      index = tree.blobs.find {|blob| blob.name =~ /^index\./}
      @meta = parse_index index.name, index.data
    end
    
  end
end
