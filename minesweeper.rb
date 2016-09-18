require_relative 'board'
require 'byebug'
require 'yaml'

class Minesweeper
  attr_accessor :board

  def initialize(board = Board.new)
    @board = board
  end

  def commence_proceedings
    prompt
    move, pos = get_move

    if move == 'f'
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

  def get_move
    parse_move(gets.chomp)
  end

  def parse_move(move)
    move = move.scan(/[a-z0-9]/)
    [move[0].downcase] << parse_pos(move.drop(1))
  end

  def parse_pos(pos)
    pos.map(&:to_i)
  end

  def prompt
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
    puts "Enter 'new' for a new game or 'load {game_name}' to load a game"
    puts ">"
  end

  def run
    beginning_announcement
    choice = parse_game_choice(gets.chomp)
    if choice == 'new'
      play_game
    else
      game = load_game
      play_loaded_game(game)
    end
  end
  def play_game
    @board.render

    until over?
      commence_proceedings
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
