
module Gaucho
  class Page
    attr_reader :id, :pageset

    def initialize(id, pageset)
      @id = id
      @pageset = pageset
    end
  end
end
