require_relative 'tile'
require 'colorize'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    configure_grid
  end

  def configure_grid
    place_tiles
    place_bombs
    count_bombs
    start_cursor
  end

  def start_cursor
    grid[0][0].cursor = true
  end

  def each_tile(&prc)
    each_row do |row|
      row.each do |tile|
        prc.call(tile)
      end
    end
  end

  def each_row(&prc)
    @grid.each do |row|
      prc.call(row)
    end
  end

  def count_bombs
    each_tile do |tile|
      tile.neighbor_bomb_count
    end
  end

  def render
    result = "    " + (0..8).to_a.join("    ")
    @grid.each_with_index do |row, i|
      temp_row = "#{i} "
      row.each do |tile|
        temp_row << "| #{tile.to_s} |"
      end
      result << "\n" << temp_row << "\n"
    end

    puts result
  end

  def won_by_reveal?
    each_tile do |tile|
      return false if tile.hidden? && !tile.bomb
    end
    "won"
  end

  def won_by_flag?
    flagged_tiles_count = flagged_bombs_count
    flagged_tiles_count == bomb_count ? "won" : false
  end

  def flag_count
    prc = Proc.new { |t| t.flagged }
    count_tiles(&prc)
  end

  def flagged_bombs_count
    prc = Proc.new { |t| t.flagged && t.bomb }
    count_tiles(&prc)
  end

  def bomb_count
    prc = Proc.new { |t| t.bomb }
    count_tiles(&prc)
  end

  def count_tiles(&prc)
    prc ||= Proc.new { |a| true }
    count = 0

    each_tile do |tile|
      count += 1 if prc.call(tile)
    end

    count
  end

  def lost?
    each_tile do |tile|
      return "lost" if tile.revealed && tile.bomb
    end
    false
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  def place_bombs
    bomb_count = 0

    until bomb_count == 10
      row = rand(9)
      col = rand(9)

      unless @grid[row][col].bomb
        @grid[row][col].bomb = true
        bomb_count += 1
      end
    end
  end

  def place_tiles
    @grid = grid.map.with_index do |row, i|
      row.map.with_index do |tile, j|
        tile = Tile.new([i,j])
        tile.board = self
        tile
      end
    end
  end

end
