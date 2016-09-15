require_relative 'tile'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    configure_grid
  end

  def configure_grid
    place_tiles
    place_bombs
  end

  def render
    result = ""
    @grid.each do |row|
      temp_row = ""
      row.each do |col|
        temp_row << "| #{col.to_s} |"
      end
      result << "\n" << temp_row << "\n"
    end

    puts result
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][co] = value
  end

  def place_bombs
    bomb_count = 0

    until bomb_count == 10
      row = rand(10)
      col = rand(10)

      unless @grid[row][col].bomb
        @grid[row][col].bomb = true
        bomb_count += 1
      end
    end
  end

  def place_tiles
    @grid.map.with_index do |row, i|
      row.map.with_index do |col, j|
        col = Tile.new([i,j])
      end
    end
  end

end
