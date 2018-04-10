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
		playing = true
		player = "White"
		while(playing)
			puts "\n\n #{player} make your move. EG. D2D3 to move your Pawn from D2 to D3\n"
			loop do
				result = gets.chomp.upcase
				if result =~ /^[a-hA-H][1-8][a-hA-H][1-8]$/ && @board.player_move(result, player)
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