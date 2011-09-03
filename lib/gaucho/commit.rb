
module Gaucho
  class Commit
    extend Forwardable

    attr_reader :commit, :page

    # Forward Grit::Commit methods to :commit.
    def_delegators :commit, :id, :parents, :tree, :message, :author, :committer,
      :authored_date, :committed_date

    def initialize(commit_id, page)
      @page = page
      @commit = @page.pageset.repo.commit commit_id
    end
    
    # Metadata for this commit's page index.md file.
    def meta
      return @meta unless @meta.nil?
      
    end
  end
end
