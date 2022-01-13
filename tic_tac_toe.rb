require 'pry-byebug'

class TicTacToeGame
  def initialize(*players)
    @player1, @player2 = players
    @board = Array.new(3) { Array.new(3, '   ') }
  end

  def display_game
    puts board
  end

  private

  def board
    @board.map { |row| row.join('|') }.join("\r\n#{'-' * 11}\r\n")
  end

  class Player
    def initialize(number)
      @number = number
      @marker = %w[X O][number - 1]
      puts "Enter the name of Player #{@number} (#{@marker})."
      @name = gets.chomp
    end
  end
end

player1 = TicTacToeGame::Player.new(1)
player2 = TicTacToeGame::Player.new(2)
game = TicTacToeGame.new(player1, player2)
game.display_game
