require 'byebug'

class Tile
  attr_accessor :revealed, :flagged, :board, :bomb

  def initialize(pos)
    @revealed = false
    @flagged = false
    @pos = pos
    @bomb = false
  end

  def reveal
    revealed = true
  end

  def hidden?
    !@revealed
  end

  def flag
    flagged ? flagged = false : flagged = true
  end

  def neighbors
    neighbors = []
    row, col = @pos

    (row-1..row+1).to_a.each do |r|
      (col-1..col+1).to_a.each do |c|
        next if r < 0 || c < 0
        neighbors << @board[[r,c]] if @pos != [r, c] && r.between?(0,8) && @board[[r,c]] && @board[[r,c]].hidden?
      end
    end

    neighbors.compact
  end

  def explore_neighbors
    return self if @flagged 

    @revealed = true

    if !@bomb && neighbor_bomb_count == 0
      neighbors.each { |tile| tile.explore_neighbors }
    end

    self
  end

  def neighbor_bomb_count
    @bomb_count = 0

    neighbors.each do |neighbor|
      @bomb_count += 1 if neighbor.bomb
    end

    @bomb_count
  end

  def to_s
   if revealed

     if @bomb_count == 0
       "_"
     else
       "#{@bomb_count}".green
     end

   elsif flagged
     "F".red
   else
     "*"
   end
  end

  def inspect
    "position = #{@pos} bomb_count = #{@bomb_count} flagged = #{@flagged} revealed = #{@revealed} bomb = #{@bomb}"
  end
end
