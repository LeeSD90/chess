class Board
require 'colorize'
require 'yaml'
require 'fileutils'
require './lib/piece.rb'
	attr_accessor :cells, :size, :pieces, :captured

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
		@captured = []
		place_pieces
		draw
		checkmate?("White")
	end

	def save_game(player)
		begin
			FileUtils.mkdir_p './save/'
			game = [@cells, @size, @pieces, @captured, player]
			File.open('./save/save_game.yaml', "w") {|f| f.write(game.to_yaml)}
			puts "\nGame saved!\n"
			return true
		rescue
			puts "\nError!\n"
			raise
			return false
		end
	end

	def load_game()
		begin
			game = YAML.load_file('./save/save_game.yaml', 'w+')
			@cells = game[0]
			@size = game[1]
			@pieces = game[2]
			@captured = game[3]
			draw
			puts "\nGame loaded!\n"
			return game[4]
		rescue
			puts "\nError!\n"
			raise
			return false
		end
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

	def get_cell(x,y)
		if in_bounds?(x,y) then
			return @cells[x][y]
		else return false
		end
	end

	#Accepts a move in the form of a string specifiying the piece to move and where to attempt to move it E.G. "A2A3" along with the color whose turn it is
	def player_move(input, player)
		result = convert_input(input)
		origin = result[0]
		destination = result[1]
		piece = get_cell_occupant(origin.x,origin.y)

		if !piece.nil? && !(piece.side == player) then 
			return false
		else 
			return move_piece(origin, destination)
		end
	end

	def check?(player)
		king_position = @cells.flatten.select {|cell| !cell.occupant.nil? && cell.occupant.type == "King" && cell.occupant.side == player }
		king_position = [king_position[0].x.to_i, king_position[0].y.to_i]

		check_moves = []
		moves = []
		position = []
		pieces = nil

		player == "White" ? color = "Black" : color = "White"

		@cells.each do |row|
			row.each do |cell|
				piece = get_cell_occupant(cell.x, cell.y)
				if !piece.nil? && piece.side == color then
					moves = piece.get_moves(cell.x,cell.y)
					moves.each do |move|
						if move == king_position then
							if validate_move(cell, get_cell(king_position[0],king_position[1]))
								check_moves << move
							else true
							end
						else true
						end
					end
				end
			end
		end

		return check_moves.any?

	end

	def checkmate?(player)
		king_position = @cells.flatten.select {|cell| !cell.occupant.nil? && cell.occupant.type == "King" && cell.occupant.side == player }
		king = king_position[0].occupant
		king_position = [king_position[0].x.to_i, king_position[0].y.to_i]
		uncheck_moves = []

		moves = king.get_moves(king_position[0],king_position[1])
		moves.each do |move|
			if validate_move(get_cell(king_position[0],king_position[1]),get_cell(move[0],move[1]))
				temp = get_cell_occupant(move[0], move[1])
				set_cell(move[0], move[1], king)
				set_cell(king_position[0],king_position[1], nil)
				if !(check?(player))
					uncheck_moves << move
				end
				set_cell(king_position[0],king_position[1], king)
				set_cell(move[0], move[1], temp)
			end
		end
		return check?(player) && !uncheck_moves.any?
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

	#Attempts to move a piece from the specified origin to specified destination, returns true if successful false otherwise
	def move_piece(origin, destination)
		piece = get_cell_occupant(origin.x, origin.y)
		destination_piece = get_cell_occupant(destination.x, destination.y)
		if validate_move(origin, destination) then
			#If the move involves capturing a piece
			if !destination_piece.nil? then
				@captured << destination_piece
				set_cell(destination.x, destination.y, nil)
			end

			set_cell(destination.x, destination.y, piece)
			set_cell(origin.x, origin.y, nil)

			if check?(piece.side)
				puts "This move puts you in check!"
				set_cell(origin.x, origin.y, piece)
				destination_piece.nil? ? set_cell(destination.x, destination.y, nil) : set_cell(destination.x, destination.y, destination_piece)
				return false
			else
				draw
				return true
			end
		else
			return false
		end
		
	end

	#Returns true if a move is valid, false if it is not
	def validate_move(origin, destination)
		piece = get_cell_occupant(origin.x, origin.y)
		occupied = get_cell_occupant(destination.x, destination.y)

		#If an empty space on the board was specified as the origin
		if piece.nil? then puts "You specified an empty space!"; return false end

		#If the set of possible moves for the piece does not contain the destination
		if !piece.get_moves(origin.x, origin.y).include?([destination.x,destination.y]) then puts "That move is impossible!"; return false end

		#If the piece is a pawn attempting to move diagonally into an empty space
		if piece.is_a?(Pawn) && origin.y != destination.y && occupied.nil? then 
			puts "Pawns can only move diagonally when capturing a piece!"
			return false
		end

		#If the piece has unlimited movement check to ensure there are no pieces between origin and destination
		if piece.unlimited_movement? then
			if destination.x - origin.x == 0 then
				difference_x = 0
			elsif destination.x - origin.x > 0 then
				difference_x = 1
			else
				difference_x = -1
			end
			if destination.y - origin.y == 0 then
				difference_y = 0
			elsif destination.y - origin.y > 0 then
				difference_y = 1
			else
				difference_y = -1
			end
			temp_x = origin.x
			temp_y = origin.y
			until temp_x == destination.x && temp_y == destination.y
				temp_x += difference_x
				temp_y += difference_y
				if !get_cell_occupant(temp_x, temp_y).nil? && (temp_x != destination.x || temp_y != destination.y)
					puts "There is an obstruction!"
					return false
				end
			end
		end

		#Check if the destination is occupied by a friendly piece
		if !occupied.nil? && (occupied.side === piece.side) then
			puts "The destination is occupied by a friendly piece!"; return false 
		end

		return !piece.nil?
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

		#print column labels
		puts "\n"
		print (" " * (size/2 + 1))
		('a'..'h').each do |l|
			print (" " * (size-1)) + l
		end

		#print captured pieces
		if !@captured.empty? then
			print "\n\nCaptured pieces: "
			@captured.each do |piece|
				print (piece.unicode).colorize(:color => :black, :background => :white)
			end
		end
 	end

end