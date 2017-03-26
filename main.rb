#!/usr/bin/ruby

require 'curses'
require 'csv'

filename = ARGV[0]
puts filename

#Curses.init_screen
#Curses.noecho

#begin
#  nb_lines = Curses.lines
#  nb_cols = Curses.cols
#ensure
#  Curses.close_screen
#end

Curses.init_screen
Curses.curs_set(0)  # Invisible cursor

CMD_WIN_H = 4

begin
  # Building a static window
  cmdwin = Curses::Window.new(CMD_WIN_H, Curses.cols - 1, Curses.lines - CMD_WIN_H, 0)
  cmdwin.box("|", "-")
  cmdwin.setpos(1, 2)
  cmdwin.addstr("Hello")
  cmdwin.refresh

  # In this window, there will be an animation
  datawin = Curses::Window.new(Curses.lines - CMD_WIN_H - 1, Curses.cols - 1, 0, 0)
  datawin.box("|", "-")
  datawin.refresh

  2.upto(datawin.maxx - 3) do |i|
    datawin.setpos(datawin.maxy / 2, i)
    datawin << "*"
    datawin.refresh
    sleep 0.05
  end

rescue => ex
  Curses.close_screen
end
