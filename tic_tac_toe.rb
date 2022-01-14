require 'pry-byebug'

module TicTacToe
  def self.run
    puts 'Start a new game? Y/N'
    unless /yes|y/i =~ gets.chomp
      puts 'Okay, bye!'
      return
    end

    player1 = self::Player.new(1)
    player2 = self::Player.new(2)
    game = self::Game.new(player1, player2)
    game.display_game
  end

  class Game
    def initialize(*players)
      @player1, @player2 = players
      @board = Array.new(3) { Array.new(3, '   ') }
    end

    def display_game
      # TODO: display Player: {name} ({marker}) along with board
      puts board
    end

    private

    def board
      @board.map { |row| row.join('|') }.join("\r\n#{'-' * 11}\r\n")
    end
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

TicTacToe.run
