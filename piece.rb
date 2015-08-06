require 'colorize'

class Piece

  UNICODE = {
    white_pawn: "\u2659",
    white_king: "\u2654",
    black_pawn: "\u265F",
    black_king: "\u265A"
  }

  SLIDE_DIFFS = {
    :white => {
      :pawn => [[ 1,  1], [ 1, -1]],
      :king => [[ 1,  1], [ 1, -1], [-1, -1], [-1,  1]]
    },
    :black => {
      :pawn => [[-1, -1], [-1,  1]],
      :king => [[ 1,  1], [ 1, -1], [-1, -1], [-1,  1]]
    }
  }

  JUMP_DIFFS = [
    [-2, -2],
    [ 2, -2],
    [-2,  2],
    [ 2,  2]
  ]


  attr_reader :color, :rank

  attr_accessor :board, :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @rank = :pawn
    @pos = pos
  end

  def jump_diffs
    JUMP_DIFFS
  end

  def slide_diffs
    SLIDE_DIFFS
  end

  def king?
    @rank == :king
  end

  def promote_king
    @rank = :king
  end

  def white_slide_diffs
    SLIDE_DIFFS[:white]
  end

  def black_slide_diffs
    SLIDE_DIFFS[:black]
  end

  def slide_moves
    slide_moves = []


    slide_diffs[color][rank].each do |d_pos|
      new_move = calculate_new_move(d_pos)
      slide_moves << new_move if valid_move?(new_move)
    end

    slide_moves.sort
  end

  def perform_slide(move_pos)
    return false unless board[move_pos].nil? && slide_moves.include?(move_pos)

    move(move_pos)
  end

  def move(move_pos)
    board[move_pos] = self
    board[self.pos] = nil
    self.pos = move_pos
  end

  def calculate_new_move(d_pos)
    orig_row, orig_col = pos
    d_row, d_col = d_pos
    new_row = orig_row + d_row
    new_col = orig_col + d_col

    [new_row, new_col]
  end

  def valid_move?(move_pos)
      board[move_pos].nil? &&
      in_bounds?(move_pos)
  end

  def in_bounds?(move_pos)
    move_pos.all? { |coord| coord.between?(0,7) }
  end

  def perform_jump(move_pos)
  end

  def maybe_promote
    case color
    when :black
      promote_king if self.pos.first == 0
    when :white
      promote_king if self.pos.first == 7
    end
  end

  def to_s
    case color
    when :white
      if king?
        UNICODE[:white_king].encode.underline
      else
        UNICODE[:white_pawn].encode.underline
      end
    when :black
      if king?
        UNICODE[:black_king].encode.underline
      else
        UNICODE[:black_pawn].encode.underline
      end
    end
  end
end
