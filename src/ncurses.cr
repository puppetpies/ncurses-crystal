require "./lib_ncurses"
require "./ncurses/*"

module NCurses
  alias Key = LibNCurses::Key

  # Possible integer result values
  ERR = -1
  OK  = 0

  # Default colors
  BLACK   = 0
  RED     = 1
  GREEN   = 2
  YELLOW  = 3
  BLUE    = 4
  MAGENTA = 5
  CYAN    = 6
  WHITE   = 7

  class Window
    def initialize(@window : LibNCurses::Window)
    end

    def to_unsafe
      @window
    end
  end

  def no_echo
    LibNCurses.noecho
  end

  def raw
    LibNCurses.raw
  end

  def has_colors?
    LibNCurses.has_colors
  end

  def can_change_color?
    LibNCurses.can_change_color
  end

  def start_color
    if ERR == LibNCurses.start_color
      raise "Unable to start color mode"
    end
  end

  def init_color(slot, red, green, blue)
    if ERR == LibNCurses.init_color(slot.to_i16, red.to_i16, green.to_i16, blue.to_i16)
      raise "Unable to init color"
    end
  end

  def init_color_pair(slot, foreground, background)
    if ERR == LibNCurses.init_pair(slot.to_i16, foreground.to_i16, background.to_i16)
      raise "Unable to init color pair"
    end
  end

  def init
    return if @@initialized
    scr = LibNCurses.initscr
    raise "couldn't initialize ncurses" unless scr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

  def stdscr
    scr = @@stdscr
    raise "ncurses not yet initialized" unless scr
    scr
  end

  def new_term(terminal, out_io, in_io)
    screen = LibNCurses.newterm(terminal, out_io.fd, in_io.fd)
    puts "foo"
    @@initialized = true
    @@stdscr = Window.new(screen)
  end

  def term=(screen)
    LibNCurses.set_term(screen)
    @@stdscr = Window.new(screen)
  end

  def end_win
    return unless @@initialized
    LibNCurses.endwin
    @@initialized = false
  end

  extend self
end
