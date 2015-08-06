require_relative 'piece'
require 'colorize'

class Board
  SIZE = 8

  def initialize(setup = true)
    @grid = Array.new(SIZE) { Array.new(SIZE) }
    setup_board if setup
  end

  def render
    system("clear")
    puts "    0  1  2  3  4  5  6  7"
    puts "   ________________________"
    rows.each_with_index do |row, row_index|
      print "#{row_index} |"
      row.each_with_index do |tile, col_index|
        if tile.nil?
          print "   ".colorize(:background => tile_color(row_index, col_index))
        else
          print " #{tile.to_s} ".colorize(:background => tile_color(row_index, col_index))
        end
      end
      puts "|"
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    if piece.slide_moves.include?(end_pos)
      piece.perform_slide(end_pos)
    elsif piece.jump_moves.include?(end_pos)
      piece.perform_jump(end_pos)
    else
      puts "Not a valid move!"
    end
  end

  private
  def setup_board
    add_pieces(:white)
    add_pieces(:black)
  end

  def tile_color(row, col)
    case row.even?
    when true #rows 0,2,4,6
      col.even? ? :light_white : :red
    when false #rows 1,3,5,7
      col.even? ? :red : :light_white
    end
  end

  def color_setter(color)
    return (0..2) if color == :white
    return (5..(SIZE - 1)) if color == :black
  end

  def add_pieces(color)
    color_setter(color).each do |row|
      (0..(SIZE - 1)).each do |col|
        case row.even?
        when true # even rows
          next if col.even?
          self[[row,col]] = Piece.new(self, color, [row, col])
        when false # odd rows
          next if col.odd?
          self[[row,col]] = Piece.new(self, color, [row, col])
        end
      end
    end
  end

  def rows
    @grid
  end
end

board = Board.new
board.render
