require 'gaucho'

module Gaucho
  describe Index do
    describe "#file_name" do
      it "should reflect the passed-in file_name" do
        index = Gaucho::Index.new 'index.md', 'SAMPLE'
        index.file_name.should eq 'index.md'
      end
    end
    
    describe "#meta" do
      before do
        @excerpt = "This is an excerpt\nspread over two lines."
        @more = "And this is the rest\nof the content."
        @data_simple = @excerpt
        @data_more = "#{@excerpt}\n<!-- more -->\n#{@more}"
        @data_yaml = <<-EOF.gsub(/^\s+/, '')
          Str1: A test string
          Str2: "Another test string"
          Array1: [foo, bar, baz]
          Array2: [1, 2, 3]
          --- |
          #{@data_more}
        EOF
      end
      it "should parse simple text data" do
        index = Gaucho::Index.new 'index.md', @data_simple
        index.meta.excerpt.should eq @excerpt
        index.meta.content.should eq @excerpt
      end
      it "should parse simple text data" do
        index = Gaucho::Index.new 'index.md', @data_more
        index.meta.excerpt.should eq @excerpt
        index.meta.content.should eq "#{@excerpt}\n#{@more}"
      end
      it "should parse yaml metadata + content" do
        index = Gaucho::Index.new 'index.md', @data_yaml
        index.meta.str1.should eq "A test string"
        index.meta.str2.should eq "Another test string"
        index.meta.array1.should eq %w{foo bar baz}
        index.meta.array2.should eq %w{1 2 3}
        index.meta.excerpt.should eq @excerpt
        index.meta.content.should eq "#{@excerpt}\n#{@more}"
      end
      it "should not care about --- before metadata" do
        index1 = Gaucho::Index.new 'index.md', @data_yaml
        index2 = Gaucho::Index.new 'index.md', "---\n#{@data_yaml}"
        index1.meta.to_hash.should eq index2.meta.to_hash
      end
    end
  end
end