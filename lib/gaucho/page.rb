
module Gaucho
  class Page
    attr_reader :id, :pageset

    def initialize(id, pageset)
      @id = id
      @pageset = pageset
    end

    # A list of commits for this page.
    def commits
      return @commits unless @commits.nil?
      pc = pageset.page_commits[id]
      @commits = pc.collect {|obj| Gaucho::Commit.new obj[:sha], self}
    end
  end
end
