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
  end

  def count_bombs
    @grid.each do |row|
      row.each do |col|
        col.neighbor_bomb_count
      end
    end
  end

  def render
    result = "    " + (0..8).to_a.join("    ").blue
    @grid.each_with_index do |row, i|
      temp_row = "#{i} ".blue
      row.each do |col|
        temp_row << "| #{col.to_s} |"
      end
      result << "\n" << temp_row << "\n"
    end

    puts result
  end

  def won?
    @grid.each do |row|
      row.each do |col|
        return false if col.hidden? && !col.bomb
      end
    end
    true
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
    @grid = @grid.map.with_index do |row, i|
      row.map.with_index do |col, j|
        col = Tile.new([i,j])
        col.board = self
        col
      end
    end
  end

end
