class Board
	attr_accessor :cells

	Point = Struct.new(:x, :y)

	def initialize()
		@cells = []
		8.times{|i|
			ary = []
			8.times{|j|
				ary << Point.new(i,j)
			}
			@cells << ary
		}
	end

	def draw()
		print @cells[0].count
	end

end