class Chess
require './lib/board.rb'
	attr_accessor :board

	def initialize
		@board = Board.new
		menu
	end

	def menu
		puts "\nSelect an option\n\n"
		puts "1. New Game"
		puts "2. Load Game"
		puts "3. Exit"
		loop do

			input = gets.chomp
			case input
			when '1'
				play
			when '2'
				@board.load_game
				play
			when '3'
				exit
			end
		end
	end

	def play
		puts "\nYou can input a move by specifying the cell of the piece you want to move and its destination cell.\n"
		puts "For example typing b2b3 will move the white pawn from b2 to b3"
		playing = true
		player = "White"
		while(playing)
			puts "\n\n #{player} make your move or type save to save the game and exit.\n"
			loop do
				result = gets.chomp.upcase
				if result == 'save'
					@board.save_game
					exit
				elsif result =~ /^[a-hA-H][1-8][a-hA-H][1-8]$/ && @board.player_move(result, player)
					break					
				else
					puts "\nInvalid move! Try again...\n"
				end
			end
			player == "White" ? player = "Black" : player = "White"
		end

	end

end

game = Chess.new