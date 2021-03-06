require_relative 'board'
require_relative 'hangman'
require 'colorize'

def start_game(word, board, guess_count, letters_guessed)
  game = Hangman.new(word, board, guess_count, letters_guessed)
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

def start_options
  saves = sort_saves
  puts "\nMake choice:"
  puts "Input '1': new game\nInput '2': load most recent save\nInput '3': choose save".yellow
  user_input = gets.chomp
  case user_input
  when '1'
    word = rand_word
    start_game(word, Board.new(word), 0, [])
  when '2'
    load_save(saves.first)
  when '3'
    load_specific_save(saves)
  else
    puts "Invalid input, try again\n".red
    load_save
  end
end

def load_save(file)
  save_hash = read_save(file)
  board = Board.new(save_hash['word'])
  save_hash['word'].chars.each_with_index do |char, index|
    if save_hash['letters_guessed'].include?(char)
      board.update_board(char, index)
    else
      board.update_board('_', index)
    end
  end
  start_game(save_hash['word'], board, save_hash['guess_count'], save_hash['letters_guessed'])
end

def load_specific_save(files)
  puts "\nChoose a file to load (input integer ID)".yellow
  files.each_with_index { |file, index| puts index.to_s + "  #{file}".green }
  puts "\n"
  user_input = gets.chomp.to_i
  if files[user_input].nil?
    puts 'Invalid index, try again'.red
    return load_specific_save(files)
  end
  load_save(files[user_input])
end

def sort_saves
  saves = Dir['./saves/*']
  saves.sort { |a, b| File.mtime(b) <=> File.mtime(a) }
end

def read_save(file)
  save = File.read(file)
  JSON.parse(save)
end

def play_again
  puts "\nWould you like to play again? Enter 'y' for yes or 'n' for no"
  user_input = gets.chomp.downcase
  case user_input
  when 'y'
    word = rand_word
    puts "New game start, the word is #{word}"
    start_game(word, Board.new(word), 0, [])
  when 'n'
    puts "\nGoodbye!"
  else
    puts 'Invalid input, try again'.red
    play_again
  end
end

if Dir.empty?('./saves/') == false
  start_options
else
  word = rand_word
  start_game(word, Board.new(word), 0, [])
end 

