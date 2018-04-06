class Board
require 'colorize'
require './lib/piece.rb'
	attr_accessor :cells, :size, :pieces

	class Cell
		attr_accessor :x, :y, :occupant
		def initialize(x, y, occupant = nil)
			@x = x
			@y = y
		end
	end

	def initialize()
		@size = 7
		@pieces = create_pieces
		@cells = create_board
		place_pieces
		draw
	end

	def get_cell_occupant(x,y)
		if in_bounds?(x,y) then
			return @cells[x][y].occupant
		else return false
		end
	end

	def set_cell(x,y,occupant)
		if in_bounds?(x,y) then
			@cells[x][y].occupant = occupant
			return true
		else return false
		end
	end

	def make_move(input)
		result = convert_input(input)
		origin = result[0]
		destination = result[1]
		return move_piece(origin, destination)
	end

	private

	def convert_input(input)
		#Take one from the numbers to match the boards coordinate system
		input = input.chars.map{|c| if /\A[-+]?\d+\z/ === c then c = (c.to_i - 1).to_s else c end }.join
		#Convert the letters to numbers
		input = input.gsub(/[A-H]/){|c|(("A".."H").to_a.join).index(c)}

		ary = []

		#Reverse their positions so they match the row column format of the coordinate system
		origin = Cell.new(input[1].to_i, input[0].to_i)
		destination = Cell.new(input[3].to_i, input[2].to_i)

		return origin, destination
	end

	def move_piece(origin, destination)

		if validate_move(origin, destination) then
			set_cell(destination.x, destination.y, get_cell_occupant(origin.x, origin.y))
			set_cell(origin.x, origin.y, nil)
			draw
			return true
		else
			return false
		end
		
	end

	def validate_move(origin, destination)
		piece = get_cell_occupant(origin.x, origin.y)
		occupied = get_cell_occupant(destination.x, destination.y)

		if !occupied.nil? then
			return !(occupied.side === piece.side)
		end

		return !piece.nil? && (!occupied || occupied.nil?)
	end

	#Good grief this method is a mess
	def draw()
		system 'cls'
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
					if cell.occupant.nil? then
						print cell.y%2 == 0 ? (" " * size).colorize(:background => :white) : (" " * size).colorize(:background => :red)
					else
						print cell.y%2 == 0 ? ((" " * (size/2))+cell.occupant.unicode+(" " * (size/2))).colorize(:color => :black, :background => :white) : ((" " * (size/2))+cell.occupant.unicode+(" " * (size/2))).colorize(:color => :black, :background => :red)
					end
				else
					if cell.occupant.nil? then
						print cell.y%2 == 0 ? (" " * size).colorize(:background => :red) : (" " * size).colorize(:background => :white)
					else
						print cell.y%2 == 0 ? ((" " * (size/2))+cell.occupant.unicode+(" " * (size/2))).colorize(:color => :black, :background => :red) : ((" " * (size/2))+cell.occupant.unicode+(" " * (size/2))).colorize(:color => :black, :background => :white)
					end
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
		end
		puts "\n"
		print (" " * (size/2 + 1))
		('a'..'h').each do |l|
			print (" " * (size-1)) + l
		end
	end

	def create_board
		board = []
		8.times{|i|
			ary = []
			8.times{|j|
				ary << Cell.new(i,j)
			}
			board << ary
		}

		return board
	end

	def in_bounds?(x,y)
		return (0..7).cover?(x) && (0..7).cover?(y)
	end

	def place_pieces()
		@pieces.each do |piece|
			case piece.side
			when 'White'
				case piece.type
				when 'Pawn'
					i = 0
					until get_cell_occupant(1,i).nil?
						i += 1
					end
					set_cell(1,i,piece)
				when 'Knight'
					get_cell_occupant(0,1).nil? ? set_cell(0,1,piece) : set_cell(0,6,piece)
				when 'Bishop'
					get_cell_occupant(0,2).nil? ? set_cell(0,2,piece) : set_cell(0,5,piece)
				when 'Rook'
					get_cell_occupant(0,0).nil? ? set_cell(0,0,piece) : set_cell(0,7,piece)
				when 'Queen'
					set_cell(0,4,piece)
				when 'King'
					set_cell(0,3,piece)
				end
			when 'Black'
				case piece.type
				when 'Pawn'
					i = 0
					until get_cell_occupant(6,i).nil?
						i += 1
					end
					set_cell(6,i,piece)
				when 'Knight'
					get_cell_occupant(7,1).nil? ? set_cell(7,1,piece) : set_cell(7,6,piece)
				when 'Bishop'
					get_cell_occupant(7,2).nil? ? set_cell(7,2,piece) : set_cell(7,5,piece)
				when 'Rook'
					get_cell_occupant(7,0).nil? ? set_cell(7,0,piece) : set_cell(7,7,piece)
				when 'Queen'
					set_cell(7,4,piece)
				when 'King'
					set_cell(7,3,piece)
				end
			end
		end

	end

	def create_pieces
		pieces = []
		color = "White"
		16.times do |i|
			i%2 == 0 ? color = "Black" : color = "White"
			pieces << Pawn.new(color) 
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