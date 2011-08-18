# encoding: utf-8

require './fixtures_helper'

Pageset.new 'test' do |r|
  r.write 'foo/bar.txt' => 'this is some sample content for foo'
  r.write 'baz.txt' => 'this is some sample content for bar'
  r.git_add_commit 'commit 1'

  r.append 'baz.txt' => 'bar has been modified!!!'
  r.git_add_commit 'commit 2'
end

Pageset.new 'two-pages' do |r|
  r.page 'page-one' do |p|
    p.meta 'Title' => 'Page One!', 'Tags' => %w{foo bar}
    p.content 'this is sample page one'
    r.git_add_commit 'page 1, commit 1'

    p.meta 'Title' => 'Page One Modified!', 'Tags' => %w{foo bar baz}
    r.git_add_commit 'page 1, commit 2'
  end

  r.page 'page-two' do |p|
    p.meta 'Title' => 'Page Two!', 'Tags' => %w{bar baz}
    p.content 'this is sample page two'
    r.git_add_commit 'page 2, commit 1'

    p.content 'this is sample page two, modified!'
    p.write 'foo.txt' => 'content for foo.txt'
    r.git_add_commit 'page 2, commit 2'

    p.append 'foo.txt' => 'more content for foo.txt!'
    r.git_add_commit 'page 2, commit 3'
  end
end
