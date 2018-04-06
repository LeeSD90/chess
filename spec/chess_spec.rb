require 'chess'
describe Chess do

	describe Board do

		describe '#get_cell' do

			context "given a valid cell coordinate on the board" do
				it "returns the occupant of the cell or nil if there is no occupant" do
					expect(subject.get_cell(1,1)).to be_a_kind_of(Pawn)
					expect(subject.get_cell(7,1)).to be_a_kind_of(Knight)
					expect(subject.get_cell(2,0)).to eql nil
				end
			end

			context "given an out of bounds cell coordinate" do
				it "returns false" do
					expect(subject.get_cell(-4, 3)).to eql false
					expect(subject.get_cell(3, 10)).to eql false
					expect(subject.get_cell(7, 8)).to eql false
				end
			end

		end

		describe '#set_cell' do

			context "given a valid cell coordinate and value" do
				it "sets the cell occupant to the given object and returns true" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1,2, piece)).to eql true
					expect(subject.get_cell(1,2)).to eql piece
				end
			end

			context "given an out of bounds cell coordinate" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(-4, 3, piece)).to eql false
				end
			end

		end

		describe '#move_piece' do

			context "given the coordinate of a piece on the board and valid destination for that piece" do
				it "moves the piece to the specified destination and returns true" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1,2, piece)).to eql true
					expect(subject.move_piece(piece, 2,2)).to eql true
					expect(subject.get_cell(2,2)).to eql piece
				end
			end

			context "given the coordinate of a piece on the board and an out of bounds cell coordinate" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(1, 2, piece)).to eql true
					expect(subject.move_piece(piece, -2,8)).to eql false
				end
			end

			context "given the coordinate of a piece on the board and aa destination coordinate already occupied by a friendly piece" do
				it "returns false" do
					piece = Pawn.new("White")
					piece2 = Knight.new("White")
					expect(subject.set_cell(1, 2, piece)).to eql true
					expect(subject.set_cell(2, 2, piece)).to eql true
					expect(subject.move_piece(piece, 2,2)).to eql false
				end
			end

			context "given an invalid coordinate for a piece on the board and a valid destination cell coordinate" do
				it "returns false" do
					piece = Pawn.new("White")
					expect(subject.set_cell(3, 2, piece)).to eql true
					expect(subject.move_piece(Cell.new(1,2), Cell.new(2,2)).to eql false
				end
			end

		end
	end

end