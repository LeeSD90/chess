class Piece
	attr_accessor :type, :side, :unicode

	def initialize(side)
		@side = side
	end
end

class Pawn < Piece
	def initialize(side)
		super(side)
		@type = "Pawn"
		@side == "White" ? @unicode = "\u2659" : @unicode = "\u265F"
	end
end

class Knight < Piece
	def initialize(side)
		super(side)
		@type = "Knight"
		@side == "White" ? @unicode = "\u2658" : @unicode = "\u265E"
	end
end

class Bishop < Piece
	def initialize(side)
		super(side)
		@type = "Bishop"
		@side == "White" ? @unicode = "\u2657" : @unicode = "\u265D"
	end
end

class Rook < Piece
	def initialize(side)
		super(side)
		@type = "Rook"
		@side == "White" ? @unicode = "\u2656" : @unicode = "\u265C"
	end
end

class Queen < Piece
	def initialize(side)
		super(side)
		@type = "Queen"
		@side == "White" ? @unicode = "\u2655" : @unicode = "\u265B"
	end
end

class King < Piece
	def initialize(side)
		super(side)
		@type = "King"
		@side == "White" ? @unicode = "\u2654" : @unicode = "\u265A"
	end
end

