require_relative '../tic_tac_toe.rb'
describe TicTacToe::Game do
  subject(:game) { described_class.new }
  let(:joe) { instance_double(TicTacToe::Player, name: 'Joe', marker: 'X', number: 1) }
  let(:jane) { instance_double(TicTacToe::Player, name: 'Jane', marker: 'O', number: 2) }

  before do
    allow(TicTacToe::Player).to receive(:new).and_return(joe, jane)
  end

  describe '#initialize' do
    before do
      allow(TicTacToe::Board).to receive(:new)
    end

    it 'initializes two new players' do
      expect(TicTacToe::Player).to receive(:new).twice
      game
    end

    it 'initializes a new board' do
      expect(TicTacToe::Board).to receive(:new)
      game
    end
  end

  describe '#play' do
    before do
      allow(TicTacToe::Board).to receive(:new)
      allow(game).to receive(:take_turn)
    end

    context 'when the game is over' do
      it 'does not execute the loop' do
        game.game_over = true
        expect(game).not_to receive(:take_turn)
        expect(game).not_to receive(:evaluate_game_over)
        game.play
      end
    end

    context 'when the game is over after one turn' do
      it 'executes the loop once' do
        allow(game).to receive(:evaluate_game_over) { game.game_over = true }
        expect(game).to receive(:take_turn).once
        expect(game).to receive(:evaluate_game_over).once
        game.play
      end
    end

    context 'when the game is over after two turns' do
      it 'executes the loop twice' do
        call_count = 0
        allow(game).to receive(:evaluate_game_over) do
          call_count += 1
          game.game_over = true if call_count == 2
        end

        expect(game).to receive(:take_turn).twice
        expect(game).to receive(:evaluate_game_over).twice
        game.play
      end
    end
  end

  describe '#take_turn' do
    let(:board) { instance_double(TicTacToe::Board) }

    before do
      allow(TicTacToe::Board).to receive(:new).and_return(board)
      allow(game).to receive(:to_s)
      allow(game).to receive(:puts)
      allow(board).to receive(:fill_square)
    end

    context 'when the X player is the current player' do
      before do
        game.instance_variable_set(:@current_player_index, 0)
      end

      it "retrieves the current player's name and marker" do
        expect(joe).to receive(:name)
        expect(joe).to receive(:marker)
        game.take_turn
      end

      it 'outputs an instruction to current player' do
        expect(game).to receive(:puts).with(/Joe, please type a number to mark the square./)
        game.take_turn
      end

      it "sends #fill_square message to game board with current player's marker" do
        expect(board).to receive(:fill_square).with('X')
        game.take_turn
      end

      it 'updates @current_player_index' do
        game.take_turn
        current_player_index = game.instance_variable_get(:@current_player_index)
        expect(current_player_index).to eql(1)
      end
    end

    context 'when the O player is the current player' do
      before do
        game.instance_variable_set(:@current_player_index, 1)
      end

      it "retrieves the current player's name and marker" do
        expect(jane).to receive(:name)
        expect(jane).to receive(:marker)
        game.take_turn
      end

      it 'outputs an instruction to current player' do
        expect(game).to receive(:puts).with(/Jane, please type a number to mark the square./)
        game.take_turn
      end

      it "sends #fill_square message to game board with current player's marker" do
        expect(board).to receive(:fill_square).with('O')
        game.take_turn
      end

      it 'updates @current_player_index' do
        game.take_turn
        current_player_index = game.instance_variable_get(:@current_player_index)
        expect(current_player_index).to eql(0)
      end
    end
  end

  describe '#evaluate_game_over' do
    context 'when the game is not over' do
      before do
        allow(TicTacToe::Board).to receive(:new).and_return [[' X ', ' O ', ' 3 '],
                                                             [' O ', ' 5 ', ' 6 '],
                                                             [' 7 ', ' 8 ', ' 9 ']]
      end

      it 'does not change @game_over to true' do
        game.evaluate_game_over
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).not_to be true
      end

      it 'does not output a game-ending message' do
        expect(game).not_to receive(:puts)
        game.evaluate_game_over
      end
    end

    context 'when a player wins horizontally' do
      before do
        allow(TicTacToe::Board).to receive(:new).and_return [[' X ', ' X ', ' X '],
                                                             [' O ', ' 5 ', ' 6 '],
                                                             [' 7 ', ' 8 ', ' 9 ']]
        allow(game).to receive(:to_s)
        allow(game).to receive(:puts)
      end

      it 'changes @game_over to true' do
        game.evaluate_game_over
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end

      it "outputs message with the winning player's name" do
        expect(game).to receive(:puts).with(/Joe has won the game!/)
        game.evaluate_game_over
      end
    end

    context 'when a player wins vertically' do
      before do
        allow(TicTacToe::Board).to receive(:new).and_return [[' 1 ', ' O ', ' X '],
                                                             [' X ', ' O ', ' 6 '],
                                                             [' X ', ' O ', ' 9 ']]
        allow(game).to receive(:to_s)
        allow(game).to receive(:puts)
      end

      it 'changes @game_over to true' do
        game.evaluate_game_over
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end

      it "outputs message with the winning player's name" do
        expect(game).to receive(:puts).with(/Jane has won the game!/)
        game.evaluate_game_over
      end
    end

    context 'when a player wins diagonally' do
      before do
        allow(TicTacToe::Board).to receive(:new).and_return [[' O ', ' 2 ', ' X '],
                                                             [' X ', ' O ', ' 6 '],
                                                             [' 7 ', ' X ', ' O ']]
        allow(game).to receive(:to_s)
        allow(game).to receive(:puts)
      end

      it 'changes @game_over to true' do
        game.evaluate_game_over
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end

      it "outputs message with the winning player's name" do
        expect(game).to receive(:puts).with(/Jane has won the game!/)
        game.evaluate_game_over
      end
    end

    context 'when the game ends on a tie' do
      before do
        allow(TicTacToe::Board).to receive(:new).and_return [[' O ', ' X ', ' X '],
                                                             [' X ', ' O ', ' O '],
                                                             [' O ', ' X ', ' X ']]
        allow(game).to receive(:to_s)
        allow(game).to receive(:puts)
      end

      it 'changes @game_over to true' do
        game.evaluate_game_over
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end

      it 'outputs message with the tie result' do
        expect(game).to receive(:puts).with(/Joe and Jane have tied./)
        game.evaluate_game_over
      end
    end
  end
end
