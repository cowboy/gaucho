
# More friendly looking dot-syntax access for hash keys.
# http://mjijackson.com/2010/02/flexible-ruby-config-objects
module Gaucho
  class Metadata
    def initialize(data = {})
      @data = {}
      data.each {|key, value| self[key] = value}
    end

    def to_hash
      @data
    end

    def [](key)
      @data[key.downcase.to_sym]
    end

    def []=(key, value)
      @data[key.downcase.to_sym] = if value.instance_of? Hash
        self.class.new value
      else
        value
      end
    end

    def method_missing(method, *args)
      if method.to_s =~ /^(.+)=$/
        self[$1] = args.first
      else
        self[method]
      end
    end
  end
end