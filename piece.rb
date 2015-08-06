class Piece

  UNICODE = {
    white_pawn: "\u2659",
    white_king: "\u2654",
    black_pawn: "\u265F",
    black_king: "\u265A"
  }

  attr_reader :color

  def initialize(color, pos)
    @color = color
    @king = false
    @pos = pos
  end

  def king?
    @king
  end

  def perform_slide
  end

  def perform_jump
  end

  def move_diffs
  end

  def maybe_promote
  end

  def to_s
    case color
    when :white
      if king?
        return UNICODE[:white_king].encode
      else
        return UNICODE[:white_pawn].encode
      end
    when :black
      if king?
        return UNICODE[:black_king].encode
      else
        return UNICODE[:black_pawn].encode
      end
    end
  end

end
