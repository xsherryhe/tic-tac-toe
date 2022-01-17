require 'pry-byebug'
class String
  def bold
    "\033[1m#{self}\033[0m"
  end
end

module TicTacToe
  def self.run
    loop do
      puts 'Start a new game? Y/N'.bold
      unless /yes|y/i =~ gets.chomp
        puts 'Okay, bye!'.bold
        break
      end

      players = [1, 2].map { |number| self::Player.new(number) }
      game = self::Game.new(players)
      game.play
    end
  end

  module GameOverConditions
    def evaluate_game_over
      self.game_over = evaluate_tie || evaluate_win
    end

    private

    def evaluate_tie
      return unless board.all? { |row| row.none? { |square| /\d/ =~ square } }

      puts "#{players.map(&:name).join(' and ')} have tied.".bold
      true
    end

    def win_index(configuration)
      configuration.index { |row| row.all? { |square| square == row[0] } }
    end

    def diagonals
      board.map.with_index { |row, i| [row[i], row[2 - i]] }.transpose
    end

    def winning_configuration
      [board, board.transpose, diagonals]
        .find { |configuration| win_index(configuration) }
    end

    def evaluate_win
      win = winning_configuration
      return unless win

      winning_player = players.find { |player| player.marker == win[win_index(win)][0][1] }
      puts "#{winning_player.name} has won the game!".bold
      true
    end
  end

  class Player
    attr_reader :name, :marker, :number

    def initialize(number)
      @number = number
      @marker = %w[X O][number - 1]
      puts "Enter the name of Player #{@number} (#{@marker}).".bold
      @name = gets.chomp
    end
  end

  class Game
    # TODO: separate board into its own class??
    include TicTacToe::GameOverConditions
    attr_reader :players, :board
    attr_writer :game_over

    NEXT_PLAYER_INDEX = [1, 0].freeze
    def initialize(players)
      @players = players
      @board = Array.new(3) { |row| Array.new(3) { |col| " #{row * 3 + col + 1} " } }
      @current_player_index = 0
      @occupied_squares = []
    end

    def play
      until @game_over
        take_turn
        evaluate_game_over
      end
    end

    private

    def displayed_board
      board.map { |row| row.join('|') }
    end

    def displayed_players
      players.map { |player| "Player #{player.number}: #{player.name} (#{player.marker})" }
    end

    def display
      display = displayed_board
      2.times { |i| display.insert(i * 2 + 1, '-' * 11 + ' ' * 10 + displayed_players[i]) }
      display.map! { |row| ' ' * 10 + row }
      "\r\n#{display.join("\r\n")}\r\n"
    end

    def current_player
      players[@current_player_index]
    end

    def instruction
      "\r\n#{current_player.name}, please type a number to mark the square.\r\n".bold
    end

    def select_square
      @selected_square = gets.chomp.to_i
      until @selected_square.between?(1, 9) && !@occupied_squares.include?(@selected_square)
        if @occupied_squares.include?(@selected_square)
          puts 'The square you selected has already been occupied. Please type a different number.'
        end
        puts 'Please type a number between 1 and 9 to mark the square.' unless @selected_square.between?(1, 9)
        @selected_square = gets.chomp.to_i
      end
      @occupied_squares << @selected_square
    end

    def update_board
      select_square
      @board[(@selected_square / 3.0).ceil - 1][(@selected_square - 1) % 3] =
        " #{current_player.marker} "
    end

    def take_turn
      puts instruction + display
      update_board
      @current_player_index = NEXT_PLAYER_INDEX[@current_player_index]
    end
  end
end

TicTacToe.run
