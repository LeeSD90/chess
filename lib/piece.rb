class Piece
	attr_accessor :type, :side, :unicode

	def initialize(side)
		@side = side
	end
end

class Pawn < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2659" : @unicode = "U+265F"
	end
end

class Knight < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2658" : @unicode = "U+265E"
	end
end

class Bishop < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2657" : @unicode = "U+265D"
	end
end

class Rook < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2656" : @unicode = "U+265C"
	end
end

class Queen < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2655" : @unicode = "U+265B"
	end
end

class King < Piece
	def initialize(side)
		super(side)
		@side == "White" ? @unicode = "U+2654" : @unicode = "U+265A"
	end
end

