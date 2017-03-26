module View
  class Base
    def initialize(r, c, t, l)
      @rows = r
      @cols = c
      @top = t
      @left = l

      @window = Curses::Window.new(@rows, @cols, @top, @left)
    end
  end
end
