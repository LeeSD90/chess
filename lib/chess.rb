class Chess
require 'board.rb'
	attr_accessor :board

	def initialize
		@board = Board.new
	end

end

game = Chess.new