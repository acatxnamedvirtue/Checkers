require_relative 'board'
require_relative 'piece'
require 'colorize'

class Game
  attr_reader :board

  attr_accessor :players

  def initialize(board = Board.new(true))
    @board = board
    @players = [:white, :black]
  end

  def run
    welcome
    
    until over?
      play_turn
      p board[[6,3]].all_moves unless board[[6,3]].nil?
    end

    end_game
  end


  private

  def welcome
    system("clear")
    puts "Welcome to Checkers!!!"
    sleep(2)
  end

  def end_game
    board.render
    puts "#{players.first.to_s.upcase}: You lose!"
    puts "#{players.last.to_s.upcase}: Congrats! You win!"
  end

  def over?
    no_moves? || no_pieces?
  end

  def no_moves?
    !(board.pieces.any? { |piece| piece.color == players.first && !piece.all_moves.empty? })
  end

  def no_pieces?
    board.pieces.none? { |piece| piece.color == players.first }
  end

  def play_turn
    render_board
    make_move
    switch_players!
  end

  def get_move
    begin
      puts "#{players.first.to_s.upcase}, it is your turn!"
      puts "Please enter a piece's position and a move sequence."
      puts "e.g [a,b],[[x,y],[x2,y2],[x3,y3]]"
      input = gets.chomp
      puts
      raise InvalidInputError unless valid_input?(input)
    rescue InvalidInputError => e
      system("clear")
      puts "#{e}: That was not a valid position and move sequence, try again!"
      sleep(2)
      board.render
      retry
    end

    formatted_input(input)
  end

  def make_move
    begin
      start_pos, move_sequence = get_move
      board.move(start_pos, move_sequence)
    rescue InvalidMoveError => e
      puts"#{e}: That was not a valid move, please try again!"
      retry
    end
  end

  def render_board
    board.render
  end

  def valid_input?(input)
    input = input.scan(/\d/).map(&:to_i)
    return false if input.take(2).nil?
    input.count.even? && input.count >= 4 && board[input.take(2)].color == players.first
  end

  def formatted_input(input)
    input = input.scan(/\d/).map(&:to_i)
    position = input.take(2)
    input = input.drop(2)

    move_sequence = []

    until input.empty?
      move_sequence << input.take(2)
      input = input.drop(2)
    end

    [position, move_sequence]
  end

  def switch_players!
    players.push(players.shift)
  end
end

class InvalidInputError < StandardError
end

if __FILE__ == $PROGRAM_NAME
game = Game.new

game.run
end
