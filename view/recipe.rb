require_relative './base'

module View
  class Recipe < Base
    def initialize(r, c, t, l)
      super(r, c, t, l)

      @window.box("|", "-")
    end

    def render
      @window.refresh
    end
  end
end
