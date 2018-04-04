class Board
require 'colorize'
require './lib/piece.rb'
	attr_accessor :cells, :size, :pieces

	Point = Struct.new(:x, :y, :occupant)

	def initialize()
		@size = 7
		@cells = create_board
		@pieces = create_pieces
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

	private

	def create_board
		board = []
		8.times{|i|
			ary = []
			8.times{|j|
				ary << Point.new(i,j)
			}
			board << ary
		}
		return board
	end

	def create_pieces
		pieces = []
		color = "White"
		16.times do |i|
			i%2 == 0 ? color = "Black" : color = "White"
			Pawn.new("Black") 
		end
		4.times do |i|
			i%2 == 0 ? color = "Black" : color = "White"
			pieces << Knight.new(color) << Rook.new(color) << Bishop.new(color)
		end
		pieces << Queen.new("White") << Queen.new("Black")
		pieces << King.new("White") << King.new("Black")
		return pieces
	end

end