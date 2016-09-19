# Version without cursor input implemented

require_relative 'board'
require 'byebug'
require 'yaml'
require 'remedy'

class Minesweeper
  include Remedy

  MOVES = { :right => [0, 1],
            :left => [0, -1],
            :up => [-1, 0],
            :down => [1, 0] }

  attr_accessor :board

  def initialize(board = Board.new)
    @board = board
  end

  def run
    # INCLUDE below when finished testing
    # beginning_announcement

    begin
      choice = parse_game_choice(gets.chomp)
    rescue
      puts "enter either 'new' or 'load {filename}''"
      retry
    end

    if choice == 'new'
      play_game
    else
      filename = choice.split(' ')[1]
      game = load_game(filename)
      game.play_game
    end
  end

  def parse_game_choice(choice)
    game_type = choice.split(' ')[0].downcase
    if game_type == 'new' || game_type == 'load'
      choice
    else
      raise
    end
  end

  def save?(move)
    if move == :s
      true
    else
      false
    end
  end

  def save_game(filename)
    File.write(filename, YAML::dump(self))
  end

  def get_filename
    prompt_filename
    filename = gets.chomp
  end

  def load_game(filename)
    puts "Loading game: #{filename}"
    # sleep(1)
    YAML.load_file(filename)
  end

  def play_game
    begin_game_announcement
    @board.render

    until over?
      prompt_move
      move = Keyboard.get.glyph
      if save?(move)
        filename = get_filename
        save_game(filename)
      else
        determine_move(move)
      end
      # system('clear')
      @board.render
    end

    puts "You #{over?}!"
  end

  def determine_move(move)
    if [:left, :right, :up, :down].include?(move)
      move_cursor(move)
    elsif move == :r
      reveal_tile(cursor_pos)
    elsif move == :f
      place_flag(cursor_pos)
    elsif move == :q
      puts "You quit"
      exit
    end
  end

  def move_cursor(pos)
    debugger
    new_pos = new_cursor_pos(pos)
    clear_cursor
    place_cursor(new_pos)
  end

  def place_cursor(new_move)
    @board.place_cursor(new_pos)
  end

  def new_cursor_pos(pos)
    row, col = pos
    move_row, move_col = MOVES[move]

    [ row + move_row, col + move_col ]
  end

  def cursor_pos
    @board.cursor_pos
  end

  def clear_cursor
    @board.clear_cursor
  end

  def over?
    @board.won_by_reveal? || @board.won_by_flag? || @board.lost?
  end

  def place_move(move)
    move_type, pos = parse_move(move)

    if move_type == 'f'
      place_flag(pos)
    else
      reveal_tile(pos)
      reveal_neighbors(@board[pos])
    end
  end

  def reveal_neighbors(pos)
    tile = @board[pos]
    tile.explore_neighbors
  end

  def place_flag(pos)
    @board[pos].flagged = true
  end

  def reveal_tile(pos)
    @board[pos].revealed = true
    reveal_neighbors(@board[pos])
  end

  def parse_move(move)
    move = move.scan(/[a-z0-9]/)
    [move[0].downcase] << parse_pos(move.drop(1))
  end

  def parse_pos(pos)
    pos.map(&:to_i)
  end

  def render
    @board.render
  end

  def beginning_announcement
    puts (("      " * 3) + "WELCOME").blue
    sleep(1)
    puts (("      " * 3) + "  TO  ").blue
    sleep(1)
    puts
    puts (("    " * 4) + "MINESWEEPER").red
    puts
    sleep(2)
    puts
    puts "Enter 'new' for a new game or 'load {filename}' to load a game"
    puts ">"
  end

  def begin_game_announcement
    puts "New game time"
    puts
    puts "Enter 's' to save your game"
    puts
    puts "Let's play!"
    puts
    # sleep(3)
  end

  def prompt_move
    puts "Make your move (ex: f 0,0 or r 2,3)"
    puts ">"
  end

  def prompt_filename
    puts "Save game? Ok."
    puts "Enter filename to save to"
    puts ">"
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.run
end
