module View
  class Base
    def initialize(model, r, c, t, l)
      @model = model
      @rows = r
      @cols = c
      @top = t
      @left = l

      @window = Curses::Window.new(@rows, @cols, @top, @left)
    end
  end
end
