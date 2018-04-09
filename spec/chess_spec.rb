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

		describe '#set_cell' do

			context "given a valid cell coordinate and value" do
				it "sets the cell occupant to the given object and returns true" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1,2, piece)).to eql true
					expect(subject.get_cell_occupant(1,2)).to eql piece
				end
			end

			context "given an out of bounds cell coordinate" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(-4, 3, piece)).to eql false
				end
			end

		end

		describe '#make_move' do

			context "Given a valid move as input" do
				it "moves the piece to the specified destination and returns true" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1,2, piece)).to eql true
					expect(subject.make_move("C2C3")).to eql true
					expect(subject.get_cell_occupant(2,2)).to eql piece
				end
			end

			context "Given an invalid move as input" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1, 2, piece)).to eql true
					expect(subject.move_piece("Z1B2")).to eql false
				end
			end

		end
	end

end