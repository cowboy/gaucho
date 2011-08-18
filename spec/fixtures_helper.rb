# encoding: utf-8

require 'pp'
require 'fileutils'
require 'yaml'

class Repo
  # create a new repo
  def initialize(repo_path)
    @time = Time.new(1999, 12, 31, 12, 0, 0, '-05:00')
    @repo_path = File.join 'fixtures', repo_path
    @pwd = FileUtils.pwd
    FileUtils.rm_rf @repo_path
    FileUtils.mkdir_p @repo_path
    FileUtils.cd @repo_path
    `git init .`
    yield self if block_given?
    done
  end

  # cleanup
  def done
    FileUtils.cd @pwd
  end

  # write some files
  def write(files = {}, mode = 'w')
    files.each do |path, content|
      FileUtils.mkdir_p(File.dirname path)
      File.open(path, mode) {|f| f.write "#{content}\n"}
    end
  end

  # append to some files
  def append(files)
    write files, 'a'
  end

  # git add some files
  def git_add(files = ['.'])
    files.each {|file| `git add #{file}`}
  end

  # git commit with message
  def git_commit(message = 'bloops')
    # fake author / commit dates
    @time += 86400
    author_time = "#{@time.to_i} -0500"
    @time += 86400
    commit_time = "#{@time.to_i} -0500"
    `export GIT_AUTHOR_DATE="#{author_time}"; export GIT_COMMITTER_DATE="#{commit_time}"; git commit -m "#{message}"`
  end

  # git add + commit
  def git_add_commit(message = nil)
    git_add
    git_commit message
  end
end

class Pageset < Repo
  def page(page_name, &block)
    Page.new self, page_name, &block
  end
end

class Page
  def initialize(pageset, page_name)
    @pageset = pageset
    @page_name = page_name
    yield self if block_given?
  end

  # page index file
  def index_path
    File.join(@page_name, 'index.md')
  end

  # get/set metadata
  def meta(meta = nil)
    docs = read_index
    if !meta.nil?
      docs[0].merge! meta
      write_index docs
    end
    docs[0]
  end

  # get/set content
  def content(content = nil)
    docs = read_index
    if !content.nil?
      docs[1] = content
      write_index docs
    end
    docs[1]
  end

  # get all yaml docs from this page's index.md file
  def read_index
    docs = []
    if File.exists? index_path
      File.open(index_path) {|file| YAML.each_document(file) {|doc| docs << doc}}
    end
    docs[0] = {} if docs[0].nil?
    docs[1] = '' if docs[1].nil?
    docs
  end

  # write all yaml docs to this page's index.md file
  def write_index(docs)
    # Since this script tries to simulate how user data will actually be stored,
    # ie. without extra quoting or \\u-style escaping, and because .to_yaml escapes
    # unicode and quotes multi-line strings, YAML serialization is done manually.
    metas = []
    docs[0].each do |key, value|
      metas << if value.instance_of? Array
        "#{key}: [#{value.join(', ')}]"
      else
        "#{key}: #{value}"
      end
    end
    meta = if metas.empty?
      '---'
    else
      metas.join("\n")
    end
    @pageset.write index_path => "#{meta}\n--- |\n#{docs[1]}\n"
  end

  # write some files
  def write(files = {}, mode = 'w')
    f = {}
    files.each {|path, content| f[File.join @page_name, path] = content}
    @pageset.write f, mode
  end

  # append to some files
  def append(files)
    write files, 'a'
  end
end
