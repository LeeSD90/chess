class Piece
	attr_accessor :type, :side, :unicode, :moveset

	def initialize(side)
		@side = side
	end

	def unlimited_movement?()
		return false
	end

	def get_moves(x,y)
		result = []
		@moveset.each do |move|
			row = x + move[0]
			col = y + move[1]

			if unlimited_movement?() then
				if (0..7).cover?(col) && (0..7).cover?(row) then result << [row, col] end
				while (0..7).cover?(col) && (0..7).cover?(row)
					row += move[0]
					col += move[1]
					result << [row, col]
				end
			else
				if (0..7).cover?(col) && (0..7).cover?(row) then
					result << [row, col]
				end
			end
		end
		return result
	end
end

class Pawn < Piece
	def initialize(side)
		super(side)
		@type = "Pawn"
		@side == "White" ? @unicode = "\u2659" : @unicode = "\u265F"
		@side == "White" ? @moveset = [[1,0], [1,1], [1,-1]] : @moveset = [[-1,1], [-1,0], [-1,-1]]
	end

end

class Knight < Piece
	def initialize(side)
		super(side)
		@type = "Knight"
		@side == "White" ? @unicode = "\u2658" : @unicode = "\u265E"
		@moveset = [[1,2],[-1,2],[1,-2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
	end

end

class Bishop < Piece
	def initialize(side)
		super(side)
		@type = "Bishop"
		@side == "White" ? @unicode = "\u2657" : @unicode = "\u265D"
		@moveset = [[1,1],[-1, -1],[1, -1],[-1, 1]]
	end

	def unlimited_movement?()
		return true
	end

end

class Rook < Piece
	def initialize(side)
		super(side)
		@type = "Rook"
		@side == "White" ? @unicode = "\u2656" : @unicode = "\u265C"
		@moveset = [[0,1],[1,0],[0,-1],[-1,0]]
	end

	def unlimited_movement?()
		return true
	end

end

class Queen < Piece
	def initialize(side)
		super(side)
		@type = "Queen"
		@side == "White" ? @unicode = "\u2655" : @unicode = "\u265B"
		@moveset = [[0,1],[1,0],[0,-1],[-1,0],[1,1],[-1, -1],[1, -1],[-1, 1]]
	end

	def unlimited_movement?()
		return true
	end

end

class King < Piece
	def initialize(side)
		super(side)
		@type = "King"
		@side == "White" ? @unicode = "\u2654" : @unicode = "\u265A"
		@moveset = [[0,1],[1,0],[0,-1],[-1,0],[1,1],[-1, -1],[1, -1],[-1, 1]]
	end

end

