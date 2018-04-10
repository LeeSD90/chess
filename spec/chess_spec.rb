require 'chess'
describe Chess do

	describe Board do

		describe '#get_cell_occupant' do

			context "given a valid cell coordinate on the board" do
				it "returns the occupant of the cell or nil if there is no occupant" do
					expect(subject.get_cell_occupant(1,1)).to be_a_kind_of(Pawn)
					expect(subject.get_cell_occupant(7,1)).to be_a_kind_of(Knight)
					expect(subject.get_cell_occupant(2,0)).to eql nil
				end
			end

			context "given an out of bounds cell coordinate" do
				it "returns false" do
					expect(subject.get_cell_occupant(-4, 3)).to eql false
					expect(subject.get_cell_occupant(3, 10)).to eql false
					expect(subject.get_cell_occupant(7, 8)).to eql false
				end
			end

		end

		describe '#player_move' do

			context "Given a valid move as input and a string identifying the side" do
				it "moves the piece to the specified destination and returns true" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1,2, piece)).to eql true
					expect(subject.player_move("C2C3", "White")).to eql true
					expect(subject.get_cell_occupant(2,2)).to eql piece
				end
			end

			context "Given an invalid move as input" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1, 2, piece)).to eql true
					expect(subject.player_move("Z1B2", "White")).to eql false
				end
			end

		end

		describe '#save_game' do

			it "Saves the current board state to the save file and returns true" do
				expect(subject.save_game("White")).to eql true
			end

		end

		describe '#check?' do

			it "Given a side whose king is not currently in check returns false" do
				subject = Board.new
				subject.player_move("E2E3", "White")
				subject.player_move("E3E4", "White")
				subject.player_move("E4E5", "White")
				subject.player_move("D1E2", "White")
				subject.player_move("E2E3", "White")
				subject.player_move("B2B3", "White")
				expect(subject.check?("White")).to eql false
				expect(subject.check?("Black")).to eql false
			end

			it "Given a side whose king is currently in check returns true" do
				subject.player_move("E2E3", "White")
				subject.player_move("E3E4", "White")
				subject.player_move("E4E5", "White")
				subject.player_move("D1E2", "White")
				subject.player_move("E2E3", "White")
				subject.player_move("G7G6", "Black")
				subject.player_move("F8H6", "Black")
				expect(subject.check?("White")).to eql true
			end

		end

		describe '#checkmate?' do

			it "Given a side whose king is not currently in checkmate returns false" do
				subject.player_move("E2E3", "White")
				subject.player_move("E3E4", "White")
				subject.player_move("E4E5", "White")
				subject.player_move("D1E2", "White")
				subject.player_move("E2E3", "White")
				subject.player_move("G7G6", "Black")
				subject.player_move("F8H6", "Black")
				expect(subject.checkmate?("White")).to eql false
				expect(subject.checkmate?("Black")).to eql false
			end

			it "Given a side whose king is currently in checkmate returns true" do
				subject.player_move("E2E3", "White")
				subject.player_move("E3E4", "White")

				subject.player_move("D7D6", "Black")
				subject.player_move("G7G6", "Black")
				subject.player_move("F8H6", "Black")
				subject.player_move("C8G4", "Black")
				expect(subject.checkmate?("White")).to eql true
			end

		end

	end

end