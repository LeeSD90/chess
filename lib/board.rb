class Board
require 'colorize'
	attr_accessor :cells, :size

	Point = Struct.new(:x, :y)

	def initialize()
		@size = 7
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
		alternate = true
		@cells.reverse.each do |row|
			print " " * size
			if(alternate)
				@cells.length.times do |i| print i%2 == 0 ? (" " * size).colorize(:background => :white) : (" " * size).colorize(:background => :red) end
			else
				@cells.length.times do |i| print i%2 == 0 ? (" " * size).colorize(:background => :red) : (" " * size).colorize(:background => :white) end
			end

			row.each do |cell|
				if cell.y == 0 then print "\n" + (" " * (size/2)) + (row[0].x + 1).to_s + (" " * (size/2)) end
				if(alternate)
					print cell.y%2 == 0 ? (" " * size).colorize(:background => :white) : (" " * size).colorize(:background => :red)
				else
					print cell.y%2 == 0 ? (" " * size).colorize(:background => :red) : (" " * size).colorize(:background => :white)
				end
			end
			puts
			print (" " * size)
			if(alternate)
				@cells.length.times do |i| print i%2 == 0 ? (" " * size).colorize(:background => :white) : (" " * size).colorize(:background => :red) end
			else
				@cells.length.times do |i| print i%2 == 0 ? (" " * size).colorize(:background => :red) : (" " * size).colorize(:background => :white) end
			end
			puts
			alternate ^= true
			#puts "\n" unless row[0].x == 0
		end
		puts "\n"
		print " " * (size-3)
		('a'..'h').each do |l|
			print (" " * (size-1)) + l
		end
	end

end