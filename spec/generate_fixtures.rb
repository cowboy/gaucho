# encoding: utf-8

require './fixtures_helper'

# Pageset.new 'test' do |r|
#   r.write 'foo/bar.txt' => 'this is some sample content for foo'
#   r.write 'baz.txt' => 'this is some sample content for bar'
#   r.git_add_commit 'commit 1'
# 
#   r.append 'baz.txt' => 'bar has been modified!!!'
#   r.git_add_commit 'commit 2'
# end
# 
# Pageset.new 'two-pages' do |r|
#   r.page 'page-one' do |p|
#     p.meta 'Title' => 'Page One!', 'Tags' => %w{foo bar}
#     p.content 'this is sample page one'
#     r.git_add_commit 'page 1, commit 1'
# 
#     p.meta 'Title' => 'Page One Modified!', 'Tags' => %w{foo bar baz}
#     r.git_add_commit 'page 1, commit 2'
#   end
# 
#   r.page 'page-two' do |p|
#     p.meta 'Title' => 'Page Two!', 'Tags' => %w{bar baz}
#     p.content 'this is sample page two'
#     r.git_add_commit 'page 2, commit 1'
# 
#     p.content 'this is sample page two, modified!'
#     p.write 'foo.txt' => 'content for foo.txt'
#     r.git_add_commit 'page 2, commit 2'
# 
#     p.append 'foo.txt' => 'more content for foo.txt!'
#     r.git_add_commit 'page 2, commit 3'
#   end
# end

Pageset.new 'basic' do |r|
  1.upto(3).each do |i|
    r.page "page-#{i}" do |p|
      p.meta 'Title' => "Page #{i}", 'Tags' => %w{foo bar baz}
      p.content "Sample content for page #{i}."
      r.git_add_commit "Created page #{i}."
      p.content "Modified content for page #{i}."
      p.write "file#{i}.txt" => "Sample file#{i} content"
      r.git_add_commit "Updated page #{i}."
    end
  end
end

Pageset.new 'subdir' do |r|
  %w{foo bar}.each do |subdir|
    1.upto(2).each do |i|
      r.page "#{subdir}/#{subdir}-page-#{i}" do |p|
        p.meta 'Title' => "Page #{i}", 'Tags' => %w{foo bar baz}
        p.content "Sample content for #{subdir} page #{i}."
        r.git_add_commit "Created #{subdir} page #{i}."
        p.content "Modified content for #{subdir} page #{i}."
        p.write "file#{i}.txt" => "Sample file#{i} content"
        r.git_add_commit "Updated #{subdir} page #{i}."
      end
    end
  end
end
