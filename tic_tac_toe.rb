require 'pry-byebug'

module TicTacToe
  def self.run
    puts 'Start a new game? Y/N'
    unless /yes|y/i =~ gets.chomp
      puts 'Okay, bye!'
      return
    end

    players = [1, 2].map { |number| self::Player.new(number) }
    game = self::Game.new(players)
    game.display_game
  end

  class Game
    def initialize(players)
      @players = players
      @board = Array.new(3) { Array.new(3, '   ') }
    end

    def display_game
      puts board_with_players
    end

    private

    def board_with_players
      @displayed_board = @board.map { |row| row.join('|') }
      2.times { |i| @displayed_board.insert(i * 2 + 1, '-' * 11 + ' ' * 10 + players[i]) }
      @displayed_board
    end

    def players
      @players.map { |player| "Player #{player.number}: #{player.name} (#{player.marker})" }
    end
  end

  class Player
    attr_reader :name, :marker, :number

    def initialize(number)
      @number = number
      @marker = %w[X O][number - 1]
      puts "Enter the name of Player #{@number} (#{@marker})."
      @name = gets.chomp
    end
  end
end

TicTacToe.run
