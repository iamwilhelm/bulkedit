require_relative './base'

module View
  class Table < Base
    def initialize(model, r, c, t, l)
      super(model, r, c, t, l)
      @window.setpos(0, 0)
    end

    def render
      @window.clear

      @model.dataset[:headers].each do |header|
        if @model.highlight_fields.include?(header)
          @window.addstr("*")
          @window.addstr(header)
          @window.addstr("*")
        else
          @window.addstr(header)
        end
        @window.addstr("\t")
      end
      @window.addstr("\n")
      @window.addstr("-" * @cols)

      # have to use view parameters of model to calculate a projection
      cropped_data = @model.dataset[:data]
      cropped_data.each { |row|
        row.to_a.each { |f|
          if @model.highlight_fields.include?(f[0])
            @window.addstr("*")
            @window.addstr(f[1])
            @window.addstr("*")
          else
            @window.addstr(f[1])
          end
          @window.addstr("\t")
        }
        @window.addstr("\n")
      }

      @window.refresh
    end

    def header_to_s(header)
      header.join("\t").concat("\n")
    end

    def row_to_s(row)
    end
  end
end
