require_relative 'board'
require 'byebug'

class Minesweeper
  attr_accessor :board

  def initialize
    @board = Board.new
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

  def run
    until over?

    end

    puts "You #{over?}!"
  end

  def over?
    @board.won? || @board.lost?
  end

  def render
    @board.render
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.render
  game.commence_proceedings
  game.render
end
