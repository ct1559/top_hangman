require_relative 'board'
require_relative 'hangman'

def start_game
  word = rand_word
  board = Board.new(word)
  game = Hangman.new(word, board, 0, [])
  game.play
  play_again
end

def rand_word
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

def play_again
  puts "\nWould you like to play again? Enter 'y' for yes or 'n' for no"
  user_input = gets.chomp.downcase
  case user_input
  when 'y'
    start_game
  when 'n'
    puts "\nGoodbye!"
  else
    puts 'Invalid input, try again'
    play_again
  end
end

start_game
