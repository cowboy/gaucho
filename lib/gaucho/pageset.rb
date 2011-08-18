
require 'grit'
require 'pp'

module Gaucho
  class Page
    attr_reader :id
    def initialize(pageset, id, commits)
    end
  end

  class Pageset
    include Enumerable

    attr_reader :repo

    def initialize(repo, options = {})
      # Init repo
      @repo = repo
      @repo = Grit::Repo.new(@repo) unless repo.instance_of? Grit::Repo

      # TODO: allow a subdir to specified
      @subdir = ''
    end

    # Allow enumeration.
    def each
      if block_given? then
        pages.each {|page| yield page}
      else
        to_enum
      end
    end

    # Get a specific page by its id.
    def [](id)
      pages
      @pages_by_id[id]
    end

    # Get all pages.
    def pages
      return @pages unless @pages.nil?

      # Build pages.
      @pages = []
      @pages_by_id = {}
      page_commits.each do |id, commits|
        page = Gaucho::Page.new(self, id, commits)
        @pages << page
        @pages_by_id[id] = page
      end
      @pages
    end

    # Get commit index for this repo.
    def page_commits
      return @page_commits unless @page_commits.nil?

      # Build page commit index.
      @page_commits = Hash.new {|h, k| h[k] = []}

      log = @repo.git.native(:log, {pretty: 'oneline', name_only: true,
        reverse: true, timeout: false})

      sha = nil
      log.split("\n").each do |line|
        if line =~ /^([0-9a-f]{40})/
          # Line is SHA, save for later.
          sha = $1
        elsif line =~ %r{^#{@subdir}(.*?)/(.*)}
          # Line is file path, push last seen SHA + file path onto this page's
          # array.
          pc = @page_commits[$1]
          # Create new object for this SHA, if necessary.
          pc << {sha: sha, files: []} if pc.empty? || sha != pc.last[:sha]
          # Push file onto this SHA's files array.
          pc.last[:files] << $2
        end
      end
      @page_commits
    end
  end
end
