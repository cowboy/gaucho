
module Gaucho
  class Page
    attr_reader :id

    def initialize(id, commits)
      @id = id
    end
  end
end
