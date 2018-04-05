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
	end

	#Good grief this method is a mess
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
			#puts "\n" unless row[0].x == 0
		end
		puts "\n"
		print " " * (size * 0.7)
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
				ary << Cell.new(i,j)
			}
			board << ary
		}

		board = place_pieces(board)
		return board
	end

	def place_pieces(board)
		@pieces.each do |piece|
			case piece.side
			when 'White'
				case piece.type
				when 'Pawn'
					i = 0
					until board[1][i].occupant.nil?
						i += 1
					end
					board[1][i].occupant = piece
				when 'Knight'
					board[0][1].occupant.nil? ? board[0][1].occupant = piece : board[0][6].occupant = piece
				when 'Bishop'
					board[0][2].occupant.nil? ? board[0][2].occupant = piece : board[0][5].occupant = piece
				when 'Rook'
					board[0][0].occupant.nil? ? board[0][0].occupant = piece : board[0][7].occupant = piece
				when 'Queen'
					board[0][4].occupant = piece
				when 'King'
					board[0][3].occupant = piece
				end
			when 'Black'
				case piece.type
				when 'Pawn'
					i = 0
					until board[6][i].occupant.nil?
						i += 1
					end
					board[6][i].occupant = piece
				when 'Knight'
					board[7][1].occupant.nil? ? board[7][1].occupant = piece : board[7][6].occupant = piece
				when 'Bishop'
					board[7][2].occupant.nil? ? board[7][2].occupant = piece : board[7][5].occupant = piece
				when 'Rook'
					board[7][0].occupant.nil? ? board[7][0].occupant = piece : board[7][7].occupant = piece
				when 'Queen'
					board[7][4].occupant = piece
				when 'King'
					board[7][3].occupant = piece
				end
			end
		end

		return board
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