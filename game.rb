require_relative 'board'
require_relative 'piece'
require 'colorize'

class Game
  attr_reader :board

  def initialize(board = Board.new(true))
    @board = board
  end

  def run
  end
end

if __FILE__ == $PROGRAM_NAME
game = Game.new

game.run
end
