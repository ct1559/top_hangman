# This class creates the game board
class Board
	attr_accessor :game_board, :correct_letter_count
	def initialize(word)
		@game_board = generate_board(word)
		@correct_letter_count = 0
	end
  
	def generate_board(word)
		board_arr = []
		word.chars.each {board_arr.push(' _ ')}
		board_arr
	end

	def update_board(letter, index)
		@game_board[index] = " #{letter} "
		@correct_letter_count += 1
	end

end
