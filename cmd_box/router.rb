require_relative './parser'

module CmdBox
  class Router
    def initialize(model)
      @model = model
    end

    def input(char, &block)
      # move cursor around and add to or remove
      $logger.info

      $logger.info char
      if char == 127 # backspace
        @model.remove_char_at_cursor()
      elsif char == 10 # enter
        $logger.info "Execute command?"
      elsif char == 27 # escape
        $logger.info "Escape mode"
      elsif char == Curses::Key::LEFT
        @model.move_cursor_left
      elsif char == Curses::Key::RIGHT
        @model.move_cursor_right
      elsif char == Curses::Key::UP
        # do nothing
      elsif char == Curses::Key::DOWN
        # do nothing
      elsif char == 1  # beginning of line
        @model.move_cursor_to_beginning
      elsif char == 5  # end of line
        @model.move_cursor_to_end
      else
        begin
          @model.add_char_at_cursor(char)
        rescue TypeError => err
          if err.message =~ /no implicit conversion of Fixnum into String/
            $logger.error "Don't know what to do with key: #{char}"
          else
            throw err
          end
        end
      end

      # parse the command

      # if it's a complete command, yield to block

      # otherwise, return where it's wrong (and update the model?)
    end

  end
end
