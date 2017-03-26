require_relative './base'

module View
  class Recipe < Base
    def initialize(model, r, c, t, l)
      super(model, r, c, t, l)

      @window.box("|", "-")
    end

    def render
      @window.refresh
    end
  end
end
