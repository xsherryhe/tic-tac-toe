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
    game.play
    game.display_game
  end

  class Game
    # TODO: separate board into its own class??
    NEXT_PLAYER_INDEX = [1, 0].freeze
    def initialize(players)
      @players = players
      @board = Array.new(3) { |row| Array.new(3) { |col| " #{row * 3 + col + 1} " } }
      @current_player_index = 0
      @occupied_squares = []
      @game_over = false
    end

    def play
      take_turn until @game_over
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

    def current_player
      @players[@current_player_index]
    end

    def instruction
      "\r\n#{current_player.name}, please type a number to mark the square."
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
      evaluate_win
    end

    def evaluate_win
      # TODO: evaluate when to end the game
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
