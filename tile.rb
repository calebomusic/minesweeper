
class Tile
  attr_accessor :revealed, :flagged, :board

  def initialize(bomb = false, pos)
    @bomb = bomb
    @revealed = false
    @flagged = false
    @pos = pos
  end

  def reveal
    revealed = true
  end

  def flag
    flagged ? flagged = false : flagged = true
  end

  def neighbors
    neighbors = []
    row, col = @pos

    (row-1..row+1).to_a.each do |r|
      (col-1..col+1).to_a.each do |c|
        neighbors << @board[r][c] if @board[r] || @board[r][c]
      end
    end

    neighbors
  end

  # def explore_neighbors
  #   return false if neighbors.any? { |neighbor| neighbor.bomb }
  #   neighbors
  # end

  def neighbor_bomb_count
    @bomb_count = 0

    neighbors.each do |neighbor|
      @bomb_count += 1 if neighbor.bomb
    end

     @bomb_count
  end
end
