class Chess
require './lib/board.rb'
	attr_accessor :board

	def initialize
		@board = Board.new
		play
	end

	def play
		puts "\nPlayer one (White) make your move. EG. D2D3 to move your Pawn from D2 to D3\n"

		loop do
			result = gets.chomp.upcase
			if result =~ /^[a-hA-H][1-8][a-hA-H][1-8]$/
				
				result = @board.convert_input(result)

				piece = @board.get_cell(result[0].x, result[0].y)
				if @board.move_piece(piece, result[1])
					break
				end
			else
				puts "Invalid move! Try again..."
			end
		end

	end

end

game = Chess.new