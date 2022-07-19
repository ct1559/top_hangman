require_relative 'board'

# Hangman class is reposible for running game logic
class Hangman
	def initialize 
		@word = ''
		@board = Board.new(@word)
		@guess_count = 0
		@letters_guessed = []
		@game_over = false
	end

	def play
	end
end
