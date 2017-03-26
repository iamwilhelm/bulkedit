#!/usr/bin/ruby

require 'curses'
require 'csv'
require 'logger'

CMD_WIN_H = 4
RECIPE_WIN_W = 20

filepath = ARGV[0]

Curses.init_screen
Curses.curs_set(0)  # Invisible cursor
logger = Logger.new("./logs/app.log")

begin
  # recipe window for list of commands
  recipewin = Curses::Window.new(Curses.lines, RECIPE_WIN_W, 0, 0)
  recipewin.box("|", "-")
  recipewin.refresh

  # command window to enter in commands
  cmdwin = Curses::Window.new(CMD_WIN_H, Curses.cols - RECIPE_WIN_W, Curses.lines - CMD_WIN_H, RECIPE_WIN_W)
  cmdwin.keypad = true    # interpret keypad
  # cmdwin.nodelay = true  # don't wait for user input
  cmdwin.box("|", "-")
  cmdwin.setpos(1, 2)
  cmdwin.addstr("$ ")
  cmdwin.refresh

  # In this window, there will be data
  datawin = Curses::Window.new(Curses.lines - CMD_WIN_H, Curses.cols - RECIPE_WIN_W, 0, RECIPE_WIN_W)
  datawin.refresh

  # load the data
  dataset = {}
  CSV.open(filepath, headers: true) do |csv|
    dataset[:data] = csv.read
    dataset[:headers] = csv.headers
  end
  datawin.addstr(dataset[:headers].join("\t").concat("\n"))
  datawin.addstr(dataset[:data].map { |row| row.to_a.map { |f| f[1] }.join("\t") }.join("\n"))
  datawin.refresh

  while true do
    key = cmdwin.getch
    cmdwin.refresh
  end

rescue => err
  logger.error [err.message, err.backtrace.join("\n")].join("\n")
  Curses.close_screen
end
