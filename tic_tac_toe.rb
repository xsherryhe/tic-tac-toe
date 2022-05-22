class String
  def bold
    "\033[1m#{self}\033[0m"
  end

  def separate_line
    "\r\n#{self}"
  end
end

module TicTacToe
  def self.run
    loop do
      puts 'Start a new game? Y/N'.separate_line.bold
      unless /yes|y/i =~ gets.chomp
        puts 'Okay, bye!'.bold
        break
      end

      game = self::Game.new
      game.play
    end
  end

  module GameOverConditions
    def evaluate_game_over
      self.game_over = evaluate_win || evaluate_tie
    end

    private

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

    def game_end_display(result)
      "#{result}\r\n#{self}".separate_line.bold
    end

    def evaluate_win
      win = winning_configuration
      return unless win

      winning_player = players.find do |player|
        player.marker == win[win_index(win)][0][1]
      end
      puts game_end_display("#{winning_player.name} has won the game!")
      true
    end

    def evaluate_tie
      return unless board.all? { |row| row.none? { |square| /\d/ =~ square } }

      puts game_end_display("#{players.map(&:name).join(' and ')} have tied.")
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

    def to_s
      "Player #{number}: #{name} (#{marker})"
    end
  end

  class Board < Array
    def initialize
      super(3) { |row| Array.new(3) { |col| " #{row * 3 + col + 1} " } }
      @occupied_squares = []
    end

    def rows
      map { |row| row.join('|') }
    end

    def fill_square(marker)
      select_square
      self[(@selected_square / 3.0).ceil - 1][(@selected_square - 1) % 3] =
        " #{marker} "
    end

    private

    def select_square
      @selected_square = valid_input
      @occupied_squares << @selected_square
    end

    def valid_input
      input = gets.chomp.to_i
      until input.between?(1, 9) && !@occupied_squares.include?(input)
        display_selected_error if @occupied_squares.include?(input)
        display_range_error unless input.between?(1, 9)
        input = gets.chomp.to_i
      end
      input
    end

    def display_selected_error
      puts 'The square you selected has already been occupied. ' \
           'Please type a different number.'
    end

    def display_range_error
      puts 'Please type a number between 1 and 9 to mark the square.'
    end
  end

  class Game
    include TicTacToe::GameOverConditions
    attr_reader :players, :board
    attr_writer :game_over

    NEXT_PLAYER_INDEX = [1, 0].freeze
    def initialize
      @players = [1, 2].map { |number| TicTacToe::Player.new(number) }
      @board = TicTacToe::Board.new
      @current_player_index = 0
    end

    def play
      until @game_over
        take_turn
        evaluate_game_over
      end
    end

    def to_s
      format(board.rows)
    end

    def take_turn
      current_player = players[@current_player_index]
      puts "#{current_player.name}, please type a number to mark the square."
        .separate_line.bold
      puts self
      board.fill_square(current_player.marker)
      @current_player_index = NEXT_PLAYER_INDEX[@current_player_index]
    end

    private

    def format(display)
      spacing = ' ' * 10
      2.times do |i|
        display.insert(i * 2 + 1,
                       "#{(['-' * 3] * 3).join('+')}#{spacing}#{players[i]}")
      end
      display.map! { |row| "#{spacing}#{row}" }
      display.join("\r\n").separate_line
    end
  end
end

TicTacToe.run
