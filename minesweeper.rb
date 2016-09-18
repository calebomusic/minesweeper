require_relative 'board'
require 'byebug'
require 'yaml'

class Minesweeper
  attr_accessor :board

  def initialize(board = Board.new)
    @board = board
  end

  def commence_proceedings(move)
    move_type, pos = parse_move(move)

    if move_type == 'f'
      place_flag(pos)
    else
      reveal_tile(pos)
      reveal_neighbors(@board[pos])
    end
  end

  def reveal_neighbors(tile)
    tile.explore_neighbors
  end

  def place_flag(pos)
    @board[pos].flagged = true
  end

  def reveal_tile(pos)
    @board[pos].revealed = true
  end

  def save?(move)
    if move.split(' ').downcase == 'save'
      true
    else
      false
    end
  end

  def parse_move(move)
    move = move.scan(/[a-z0-9]/)
    [move[0].downcase] << parse_pos(move.drop(1))
  end

  def parse_pos(pos)
    pos.map(&:to_i)
  end

  def prompt_move
    puts "Make your move (ex: f 0,0 or r 2,3)"
    puts ">"
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

  def run
    # INCLUDE below when finished testing
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
      filename = choice.split('')[1]
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

  def save_game

  end

  def load_game(filename)
    puts "Loading game: #{filename}"
    sleep(1)
    YAML.load_file(filename)
  end

  def begin_game_announcement
    puts "New game time"
    puts
    puts "Enter 'save {filename}' to save your game"
    puts
    puts "Let's play!"
    puts
    sleep(3)
  end

  def play_game
    begin_game_announcement
    @board.render

    until over?
      move = gets.chomp
      if save?(move)
        filename = move
        save(filename)
      else
        commence_proceedings(move)
      end
      @board.render
    end

    puts "You #{over?}!"
  end

  def over?
    @board.won_by_reveal? || @board.won_by_flag? || @board.lost?
  end

  def render
    @board.render
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.run
end
