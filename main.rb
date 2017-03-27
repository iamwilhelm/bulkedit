#!/usr/bin/ruby

require 'curses'
require 'csv'
require 'logger'

require './model/root'
require './view/recipe'
require './view/cmd'
require './view/table'
require './cmd_box/router'
require './msg'


$logger = Logger.new("./log/app.log")
filepath = ARGV[0]

Curses.init_screen
Curses.start_color if Curses.has_colors?
$logger.info "Can change color? #{Curses.can_change_color?}"
Curses.curs_set(0)  # Invisible cursor
Curses.noecho       # don't echo the keyboard. We'll handle all the writing
Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_WHITE)

RECIPE_WIN_H = Curses.lines
RECIPE_WIN_W = 20
CMD_WIN_H = 4
CMD_WIN_W = Curses.cols - RECIPE_WIN_W
DATA_WIN_H = Curses.lines - CMD_WIN_H
DATA_WIN_W = Curses.cols - RECIPE_WIN_W

begin
  # load the data
  dataset = {}
  CSV.open(filepath, headers: true) do |csv|
    dataset[:data] = csv.read
    dataset[:headers] = csv.headers
  end

  model = Model::Root.new(dataset)

  recipe_view = View::Recipe.new(model, RECIPE_WIN_H, RECIPE_WIN_W, 0, 0)
  cmd_view = View::Cmd.new(model, CMD_WIN_H, CMD_WIN_W, Curses.lines - CMD_WIN_H, RECIPE_WIN_W)
  table_view = View::Table.new(model, DATA_WIN_H, DATA_WIN_W * 2, 0, RECIPE_WIN_W)

  views = [recipe_view, cmd_view, table_view]
  views.each { |view| view.render }

  router = CmdBox::Router.new(model)

  while true do
    router.input(cmd_view.getch).route do |msg|
      case msg[:type]
      when Msg::FILTER
        $logger.info "change projection of dataset to filter"

      when Msg::SELECT
        $logger.info "change projection of dataset to select"

      when Msg::HIGHLIGHT_FIELD
        model.highlight_fields = msg[:fields]
      else
        $logger.error "Unknown message type: #{msg[:type]}"
      end
    end

    views.each { |view| view.render }
  end

rescue => err
  $logger.error [err.message, err.backtrace.join("\n")].join("\n")
  Curses.close_screen
end
