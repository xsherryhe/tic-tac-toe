require_relative '../tic_tac_toe.rb'

describe TicTacToe do
  describe '::run' do
    let(:game) { instance_double(TicTacToe::Game) }

    before do
      allow(TicTacToe).to receive(:puts)
      allow(TicTacToe::Game).to receive(:new).and_return(game)
      allow(game).to receive(:play)
    end

    context 'when the user does not want to start a new game' do
      before do
        allow(TicTacToe).to receive(:gets).and_return('no')
      end

      it 'outputs a goodbye statement to the user' do
        expect(TicTacToe).to receive(:puts).with(/bye/)
        TicTacToe.run
      end

      it 'exits the method' do
        expect(TicTacToe::Game).not_to receive(:new)
        expect(game).not_to receive(:play)
        TicTacToe.run
      end
    end

    context 'when the user wants to start one new game and then quit' do
      before do
        allow(TicTacToe).to receive(:gets).and_return('yes', '')
      end

      it 'starts and plays a new game once' do
        expect(TicTacToe::Game).to receive(:new).once
        expect(game).to receive(:play).once
        TicTacToe.run
      end
    end

    context 'when the user wants to start two new games and then quit' do
      before do
        allow(TicTacToe).to receive(:gets).and_return('YES', 'y', 'nah')
      end

      it 'starts and plays a new game twice' do
        expect(TicTacToe::Game).to receive(:new).twice
        expect(game).to receive(:play).twice
        TicTacToe.run
      end
    end
  end
end
