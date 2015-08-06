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

  def move(start_pos, move_sequence)
    self[start_pos].perform_moves(move_sequence)
  end

  def dup
    dup_board = Board.new(false)

    pieces.each do |piece|
      Piece.new(dup_board, piece.color, piece.pos.dup)
    end

    dup_board
  end

  def pieces
    rows.flatten.compact
  end

  private
  def setup_board
    add_pieces(:white)
    add_pieces(:black)
  end

  def tile_color(row, col)
    row.even? ? (col.even? ? :light_white : :red) : (col.even? ? :red : :light_white)
  end

  def color_setter(color)
    return (0..2) if color == :white
    return (5..(SIZE - 1)) if color == :black
  end

  def add_pieces(color)
    color_setter(color).each do |row|
      (0..(SIZE - 1)).each do |col|
          Piece.new(self, color, [row, col]) if (row.even? && col.odd?) ||
                                                  (row.odd? && col.even?)
      end
    end
  end

  def rows
    @grid
  end
end
