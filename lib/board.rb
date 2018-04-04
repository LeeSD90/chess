class Board
	attr_accessor :squares

	def initialize()
		@squares = []
		8.times{|i|
			8.times{|j|
				@squares << [i,j]}}
	end
	
end