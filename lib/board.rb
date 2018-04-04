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
		puts "\n\n"
		@cells.reverse.each do |row|
			print (row[0].x + 1).to_s + " |"
			row.each do |cell|
				print "______|"
			end
			puts
			puts "\n\n" unless row[0].x == 0
		end
		puts "\n"
		('a'..'h').each do |l|
			print "      " + l
		end
	end

end