require_relative './base'

module View
  class Cmd < Base
    def initialize(r, c, t, l)
      super(r, c, t, l)

      #@window.nodelay = true  # don't wait for user input
      @window.keypad = true    # interpret keypad
      @window.box("|", "-")
      @window.setpos(1, 2)
      @window.addstr("$ ")
    end

    def render
      @window.refresh
    end

    def getch
      @window.getch
    end
  end
end
