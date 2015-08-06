require_relative 'piece'
require 'colorize'

class Board
  SIZE = 8

  def initialize(setup = true)
    @grid = Array.new(SIZE) { Array.new(SIZE) }
    setup_board if setup
  end

  def setup_board
    #0,2 #1
    add_white_pieces
    #5,7 #6
    add_black_pieces
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

  def tile_color(row, col)
    case row.even?
    when true #rows 0,2,4,6
      case col.even?
      when true
        :light_white
      when false
        :red
      end
    when false #rows 1,3,5,7
      case col.even?
      when true
        :red
      when false
        :light_white
      end
    end
  end

  def rows
    @grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def move(start_pos, move_pos)
    self[start_pos].move(move_pos)
  end

  def add_white_pieces
    rows.each_with_index do |row, row_index|
      next if row_index > 2
      row.each_with_index do |_, col_index|
        case row_index.even?
        when true # even rows
          next if col_index.even?
          self[[row_index,col_index]] = Piece.new(self, :white, [row_index, col_index])
        when false # odd rows
          next if col_index.odd?
          self[[row_index,col_index]] = Piece.new(self, :white, [row_index, col_index])
        end
      end
    end
  end

  def add_black_pieces
    rows.map.with_index do |row, row_index|
      next if row_index < 5
      row.map.with_index do |_, col_index|
        case row_index.even?
        when true # even rows
          next if col_index.even?
          self[[row_index,col_index]] = Piece.new(self, :black, [row_index, col_index])
        when false # odd rows
          next if col_index.odd?
          self[[row_index,col_index]] = Piece.new(self, :black, [row_index, col_index])
        end
      end
    end
  end
end

board = Board.new
board.render
