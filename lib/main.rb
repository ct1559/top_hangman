require_relative 'board'
require_relative 'hangman'

def start_game
	word = get_word
	board = Board.new(word)
	board.game_board.each { |element| print element }
	puts "\n\n"
	puts word
end

def get_word
 contents = File.readlines('google-10000-english-no-swears.txt')
 list = []
 contents.each { |line| list.push(line.chomp) }
 filtered_list = filter_word_list(list)
 random_index = rand(filtered_list.length)
 filtered_list[random_index]
end

def filter_word_list(list)
	list.select { |word| word.length.between?(5, 12) }
end

start_game
