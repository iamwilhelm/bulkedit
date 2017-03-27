module Model
  class Root
    attr_reader :dataset, :cmd_str

    # TODO need a way to communicate what changed...so views know when to refresh
    def initialize(dataset)
      @dataset = dataset
      @cursor = { col: 0 }
      @focus = :cmd
      @transforms = []
      @cmd_str = ""
    end

    def add_char_at_cursor(char)
      @cmd_str.insert(@cursor[:col], char)
      @cursor[:col] += 1
    end

    def remove_char_at_cursor()
      @cursor[:col] -= 1
      if @cursor[:col] < 0
        @cursor[:col] = 0
        return
      end
      
      @cmd_str.slice!(@cursor[:col])
      $logger.info @cmd_str
    end

    def move_cursor_left()
      return if @cursor[:col] == 0
      @cursor[:col] -= 1
    end

    def move_cursor_right()
      return if @cursor[:col] > (@cmd_str.length + 1)
      @cursor[:col] += 1
    end

  end
end
