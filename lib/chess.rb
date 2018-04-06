class Chess
require './lib/board.rb'
	attr_accessor :board

	def initialize
		@board = Board.new
		play
	end

	def play
		playing = true
	
		while(playing)
			puts "\nPlayer one (White) make your move. EG. D2D3 to move your Pawn from D2 to D3\n"
			loop do
				result = gets.chomp.upcase
				if result =~ /^[a-hA-H][1-8][a-hA-H][1-8]$/ && @board.make_move(result)
					break					
				else
					puts "\nInvalid move! Try again...\n"
				end
			end
		end

	end

end

game = Chess.new