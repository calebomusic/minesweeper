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
    beginning_announcement

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
    sleep(1)
    YAML.load_file(filename)
  end

  def play_game
    begin_game_announcement
    render

    until over?
      prompt_move
      move = Keyboard.get.to_s.to_sym
      if save?(move)
        filename = get_filename
        save_game(filename)
      else
        determine_move(move)
      end
      render
    end
    end_game_announcement
  end

  def determine_move(move)
    if [:left, :right, :up, :down].include?(move)
      move_cursor(move)
    elsif move == :r
      reveal_tile(cursor_pos)
    elsif move == :f
      place_flag(cursor_pos)
    elsif move == :q
      quitting_announcement
    end
  end

  def move_cursor(pos)
    new_pos = new_cursor_pos(pos)
    clear_cursor
    place_cursor(new_pos)
  end

  def place_cursor(new_pos)
    @board.place_cursor(new_pos)
  end

  def new_cursor_pos(pos)
    row, col = cursor_pos
    move_row, move_col = MOVES[pos]

    new_row = (row + move_row) % board_length
    new_col = (col + move_col) % board_length
    [ new_row, new_col ]
  end

  def board_length
    @board.length
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

  def reveal_neighbors(tile)
    tile.explore_neighbors
  end

  def place_flag(pos)
    @board[pos].flagged = true
  end

  def reveal_tile(pos)
    tile = @board[pos]
    tile.revealed = true
    reveal_neighbors(tile)
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

  def final_render
    # THERES A BUG HERE SOMEWHERE
    @board.reveal_all
    render
  end
  def beginning_announcement
    system('clear')
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
    sleep(1)
    system('clear')
    sleep(1)
    puts
    puts
    puts "Let's play!"
    puts
    sleep(3)
  end

  def prompt_move
    puts
    puts "Move with the arrow keys"
    puts
    puts "reveal: 'r',flag: 'f', save: 's', quit: 'q'"
  end

  def prompt_filename
    puts "Save game? Ok."
    puts "Enter filename to save to"
    puts ">"
  end

  def end_game_announcement
    sleep(3)
    puts
    clear_cursor
    puts "Oh...".red
    sleep(2)
    puts "You #{over?}!"
    sleep(1)
    final_render
    sleep(1)
    puts
    sleep(4)
    puts
    puts "Great!".white
  end

  def quitting_announcement
    sleep(1)
    puts
    puts "You quit."
    sleep(1)
    puts "Great!".white
    exit
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.run
end
