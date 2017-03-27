require_relative './base'

module View
  class Cmd < Base
    LEFT_PADDING = 2
    LEFT_BOX = 2
    def initialize(model, r, c, t, l)
      super(model, r, c, t, l)

      #@window.nodelay = true  # don't wait for user input
      @window.keypad = true    # interpret keypad
      @window.box("|", "-")
      @window.setpos(1, LEFT_PADDING)
      @window.addstr("$ ")
    end

    def setup
      @window.box("|", "-")
      @window.setpos(1, LEFT_PADDING)
      @window.addstr("$ ")
    end

    def render
      @window.clear
      setup
      @window.addstr(@model.cmd_str)
      @window.setpos(1, @model.cursor_col + LEFT_PADDING + LEFT_BOX)
      @window.refresh
    end

    def getch
      @window.getch
    end
  end
end
