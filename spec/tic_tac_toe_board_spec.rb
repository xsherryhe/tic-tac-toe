require_relative '../tic_tac_toe.rb'
describe TicTacToe::Board do
  describe '#fill_square' do
    subject(:board) { described_class.new }

    before do
      allow(board).to receive(:puts)
      board.instance_variable_set(:@occupied_squares, [5, 8, 1, 2])
    end

    it 'outputs an error message for as long as the selected square is invalid' do
      allow(board).to receive(:gets).and_return('d', '@2', '3')
      expect(board).to receive(:puts).with('Please type a number between 1 and 9 to mark the square.').twice
      board.fill_square('X')
    end

    it 'outputs an error message for as long as the selected square is out of range' do
      allow(board).to receive(:gets).and_return('23', '52', '-6', '3')
      expect(board).to receive(:puts).with('Please type a number between 1 and 9 to mark the square.').exactly(3).times
      board.fill_square('X')
    end

    it 'outputs an error message for as long the selected square is already occupied' do
      allow(board).to receive(:gets).and_return('5', '8', '1', '2', '3')
      expect(board)
        .to receive(:puts)
        .with('The square you selected has already been occupied. Please type a different number.')
        .exactly(4).times
      board.fill_square('X')
    end

    it 'outputs the appropriate error message depending on the input error' do
      allow(board).to receive(:gets).and_return('5', '@8', '()s', '1', '8', '3')
      expect(board).to receive(:puts).with('Please type a number between 1 and 9 to mark the square.').exactly(2).times
      expect(board)
        .to receive(:puts)
        .with('The square you selected has already been occupied. Please type a different number.')
        .exactly(3).times
      board.fill_square('X')
    end

    context 'when the target marker is X' do
      context 'when the selected square is 3' do
        before do
          allow(board).to receive(:gets).and_return('3')
          board.fill_square('X')
        end

        it 'fills the third square with X' do
          selected_square = board[0][2]
          expect(selected_square).to eql(' X ')
        end

        it 'adds the third square to the list of occupied squares' do
          occupied_squares = board.instance_variable_get(:@occupied_squares)
          expect(occupied_squares).to include(3)
        end
      end

      context 'when the selected square is 7' do
        before do
          allow(board).to receive(:gets).and_return('7')
          board.fill_square('X')
        end

        it 'fills the seventh square with X' do
          selected_square = board[2][0]
          expect(selected_square).to eql(' X ')
        end

        it 'adds the seventh square to the list of occupied squares' do
          occupied_squares = board.instance_variable_get(:@occupied_squares)
          expect(occupied_squares).to include(7)
        end
      end

      context 'when the selected square is 6' do
        before do
          allow(board).to receive(:gets).and_return('6')
          board.fill_square('X')
        end

        it 'fills the sixth square with X' do
          selected_square = board[1][2]
          expect(selected_square).to eql(' X ')
        end

        it 'adds the sixth square to the list of occupied squares' do
          occupied_squares = board.instance_variable_get(:@occupied_squares)
          expect(occupied_squares).to include(6)
        end
      end
    end

    context 'when the target marker is O' do
      before do
        allow(board).to receive(:gets).and_return('3')
        board.fill_square('O')
      end

      it 'fills the selected square with O' do
        selected_square = board[0][2]
        expect(selected_square).to eql(' O ')
      end

      it 'adds the selected square to the list of occupied squares' do
        occupied_squares = board.instance_variable_get(:@occupied_squares)
        expect(occupied_squares).to include(3)
      end
    end
  end
end
