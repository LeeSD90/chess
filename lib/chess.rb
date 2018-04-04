class Chess
require './lib/board.rb'
	attr_accessor :board

	def initialize
		@board = Board.new
		@board.draw
	end

end

game = Chess.new