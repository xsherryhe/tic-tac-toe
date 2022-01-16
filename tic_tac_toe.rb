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
      @board = Array.new(3) { |row| Array.new(3) { |col| " #{row * 3 + col + 1} "} }
    end

    def display_game
      puts display
    end

    private

    def board
      @board.map { |row| row.join('|') }
    end

    def players
      @players.map { |player| "Player #{player.number}: #{player.name} (#{player.marker})" }
    end

    def display
      @display = board
      2.times { |i| @display.insert(i * 2 + 1, '-' * 11 + ' ' * 10 + players[i]) }
      @display.map! { |row| ' ' * 10 + row }
      "\r\n#{@display.join("\r\n")}\r\n"
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
