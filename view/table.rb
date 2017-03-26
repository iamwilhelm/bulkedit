require_relative './base'

module View
  class Table < Base
    def initialize(model, r, c, t, l)
      super(model, r, c, t, l)
      @window.setpos(0, 0)
    end

    def render
      @window.clear

      @window.addstr(@model.dataset[:headers].join("\t")[0..DATA_WIN_W * 3 / 4].concat("\n"))
      @window.addstr(@model.dataset[:data].map { |row| row.to_a.map { |f| f[1] }.join("\t") }.join("\n"))

      @window.refresh
    end
  end
end
