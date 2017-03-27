require_relative './parser'

module CmdBox
  class Router
    def initialize(model)
      @model = model
    end

    def input(char, &block)
      # move cursor around and add to or remove
      $logger.info char
      if char == 127 # backspace
        @model.remove_char_at_cursor()
      elsif char == 10 # enter
        $logger.info "Execute command?"
      elsif char == 27 # escape
        $logger.info "Escape mode"
      else
        @model.add_char_at_cursor(char)
      end

      # parse the command

      # if it's a complete command, yield to block

      # otherwise, return where it's wrong (and update the model?)
    end

  end
end
