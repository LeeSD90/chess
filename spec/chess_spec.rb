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
				end
			end

		end

		describe '#set_cell' do

			context "given a valid cell coordinate and value" do
				it "sets the cell to the given value and returns true" do
					expect(subject.board.set_cell(1,2, "R")).to eql true
					expect(subject.board.cells[1][2]).to eql "R"
					expect(subject.board.set_cell(1,1, "Y")).to eql true
					expect(subject.board.cells[1][1]).to eql "Y"
				end
			end

			context "given an out of bounds cell coordinate" do
				it "returns false" do
					expect(subject.board.set_cell(-4, 3, "Y")).to eql false
					expect(subject.board.set_cell(3, 10, "R")).to eql false
				end
			end

			context "given an invalid value" do
				it "returns false" do
					expect(subject.board.set_cell(1, 2, "Blah")).to eql false
					expect(subject.board.set_cell(3, 4, -1)).to eql false
				end
			end

		end
	end

end