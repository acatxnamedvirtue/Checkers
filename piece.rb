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

  JUMP_DIFFS = {
    :white => {
      :pawn => [[ 2,  2], [ 2, -2]],
      :king => [[ 2,  2], [ 2, -2], [-2, -2], [-2,  2]]
    },
    :black => {
      :pawn => [[-2, -2], [-2,  2]],
      :king => [[ 2,  2], [ 2, -2], [-2, -2], [-2,  2]]
    }
  }


  attr_reader :color, :rank

  attr_accessor :board, :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @rank = :pawn
    @pos = pos
  end

  def perform_slide(move_pos)
    return false unless slide_moves.include?(move_pos)

    move(move_pos)
    maybe_promote
  end

  def perform_jump(move_pos)
    return false unless jump_moves.include?(move_pos)

    delete_piece(self.pos, move_pos)
    move(move_pos)
    maybe_promote
  end

  def to_s
    case color
    when :white
      if king?
        UNICODE[:white_king].encode
      else
        UNICODE[:white_pawn].encode
      end
    when :black
      if king?
        UNICODE[:black_king].encode
      else
        UNICODE[:black_pawn].encode
      end
    end
  end

  # private
  def jump_diffs
    JUMP_DIFFS
  end

  def slide_diffs
    SLIDE_DIFFS
  end

  def slide_moves
    slide_diffs[color][rank].map { |d_pos| calc_new_move(d_pos)}.select{|move| valid_move?(move)}
  end

  def jump_moves
    jump_moves = []

    jump_diffs[color][rank].each do |d_pos|
      new_move = calc_new_move(d_pos)
      opponent_pos = calc_opponent_pos(d_pos)

      jump_moves << new_move if valid_move?(new_move) && opponent_piece?(opponent_pos)
    end

    jump_moves
  end

  def opponent_piece?(opponent_pos)
    return false if board[opponent_pos].nil? || board[opponent_pos].color == color

    true
  end

  def delete_piece(start_pos, move_pos)
    start_row, start_col = start_pos
    move_row, move_col = move_pos
    delete_row = start_row - (start_row - move_row)/2
    delete_col = start_col - (start_col - move_col)/2

    board[[delete_row, delete_col]] = nil
  end

  def move(move_pos)
    board[move_pos] = self
    board[self.pos] = nil
    self.pos = move_pos
  end

  def calc_new_move(d_pos)
    orig_row, orig_col = pos
    d_row, d_col = d_pos
    new_row = orig_row + d_row
    new_col = orig_col + d_col

    [new_row, new_col]
  end

  def calc_opponent_pos(d_pos)
    orig_row, orig_col = pos
    d_row, d_col = d_pos
    new_row = orig_row + (d_row / 2)
    new_col = orig_col + (d_col / 2)

    [new_row, new_col]
  end

  def valid_move?(move_pos)
      board[move_pos].nil? && in_bounds?(move_pos)
  end

  def in_bounds?(move_pos)
    move_pos.all? { |coord| coord.between?(0, Board::SIZE - 1) }
  end

  def maybe_promote
    return if self.king?
    case color
    when :black
      promote_king if self.pos.first == 0
    when :white
      promote_king if self.pos.first == Board::SIZE - 1
    end
  end

  def promote_king
    @rank = :king
  end

  def king?
    @rank == :king
  end
end
