class CmdParser
  def initialize(model)
    @model = model
  end

  def input(char, &block)
    # add char to current command
    if char == Curses::Key::BACKSPACE
      @model.remove_char_at_cursor()
    else
      @model.add_char_at_cursor(char)
    end

    # parse the command

    # if it's a complete command, yield to block

    # otherwise, return where it's wrong (and update the model?)
  end

end
