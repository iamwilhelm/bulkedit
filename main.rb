#!/usr/bin/ruby

require 'curses'
require 'csv'
require 'logger'

require './view/recipe'
require './cmd_parser'
require './msg'


logger = Logger.new("./log/app.log")
filepath = ARGV[0]

Curses.init_screen
Curses.start_color if Curses.has_colors?
Curses.curs_set(0)  # Invisible cursor

RECIPE_WIN_H = Curses.lines
RECIPE_WIN_W = 20
CMD_WIN_H = 4
CMD_WIN_W = Curses.cols - RECIPE_WIN_W
DATA_WIN_H = Curses.lines - CMD_WIN_H
DATA_WIN_W = Curses.cols - RECIPE_WIN_W

begin
  # recipe window for list of commands
  recipe_view = View::Recipe.new(RECIPE_WIN_H, RECIPE_WIN_W, 0, 0)
  recipe_view.render

  # command window to enter in commands
  cmdwin = Curses::Window.new(CMD_WIN_H, CMD_WIN_W, Curses.lines - CMD_WIN_H, RECIPE_WIN_W)
  cmdwin.keypad = true    # interpret keypad
  # cmdwin.nodelay = true  # don't wait for user input
  cmdwin.box("|", "-")
  cmdwin.setpos(1, 2)
  cmdwin.addstr("$ ")
  cmdwin.refresh

  # In this window, there will be data
  datawin = Curses::Window.new(DATA_WIN_H, DATA_WIN_W * 2, 0, RECIPE_WIN_W)
  datawin.setpos(0, 0)
  datawin.refresh

  # load the data
  dataset = {}
  CSV.open(filepath, headers: true) do |csv|
    dataset[:data] = csv.read
    dataset[:headers] = csv.headers
  end


  model = {
  }

  cmd_parser = CmdParser.new

  while true do
    key = cmdwin.getch
    # send key to command parser
    cmd_parser.input(key) do |msg|
      case msg.type
      when Msg.FILTER
        # change the model
      else
        logger.info "Unknown message type"
      end
    end

    # command parser decides on complete message to send to command router

    # command router triggers action to update different models based on message

    # when dataset model gets message to X, it will change the dataset.

    # up in this loop, we call every view to blit on to the screen

    datawin.addstr(dataset[:headers].join("\t")[0..DATA_WIN_W * 3 / 4].concat("\n"))
    datawin.addstr(dataset[:data].map { |row| row.to_a.map { |f| f[1] }.join("\t") }.join("\n"))
    datawin.refresh
    cmdwin.refresh
  end

rescue => err
  logger.error [err.message, err.backtrace.join("\n")].join("\n")
  Curses.close_screen
end
