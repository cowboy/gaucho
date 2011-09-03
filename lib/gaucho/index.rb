
module Gaucho
  class Index
    attr_reader :file_name, :meta

    def initialize(file_name, data)
      @file_name = file_name
      @data = data
      parse_data
    end

    private

    # Parse index file into metadata.
    def parse_data
      docs = []
      YAML.each_document(@data) {|doc| docs << doc}# rescue nil
      docs = [{}, @data] unless docs.length == 2
      docs.first.each do |key, value|
        docs.first[key] = value.collect {|e| e.to_s} if value.instance_of? Array
      end
      @meta = Gaucho::Metadata.new docs.first

      # meta.excerpt is anything before <!--more-->, meta.content is everything
      # before + everything after.
      parts = docs.last.split(/^\s*<!--\s*more\s*-->\s*$/im)
      @meta.excerpt = (parts[0] || '').chomp
      @meta.content = @meta.excerpt + (parts[1] || '').chomp
    end
  end
end
