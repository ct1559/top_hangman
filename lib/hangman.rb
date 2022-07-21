require_relative 'board'
require 'colorize'
require 'json'

# Hangman class is reposible for running game logic
class Hangman
  def initialize(word, board, guess_count, letters_guessed)
    @word = word
    @board = board
    @guess_count = guess_count
    @letters_guessed = letters_guessed
    @game_over = false
  end

  def play
    puts @word
    puts @guess_count
    puts @game_over

    while @guess_count < 6 && @game_over == false
      puts "\nGuess Count: ".green + @guess_count.to_s + '   Remaining Guesses: '.green + (6 - @guess_count).to_s
      puts 'Guessed Letters: '.green + "#{@letters_guessed}\n"
      @board.game_board.each { |element| print element }
      puts "\n\n"
      guess = letter_or_word
      # @letters_guessed.push(guess)
      if guess.length == 1
        check_letter(guess)
      else
        check_word(guess)
      end
      @guess_count += 1
      unless @board.game_board.include?(' _ ')
        puts "\nYou correctly guessed the word!".green
        @game_over = true
      end
    end
    @board.game_board.each { |element| print element }
    puts "\n\n"
    return if @game_over == true

    puts 'You were unable to correctly guess it in 6 tries :(. The word was: ' + @word.to_s.green
  end

  def letter_or_word
    puts 'Make Choice:'
    puts "Input '1': guess letter\nInput '2': guess word\nInput '3': save game and exit:".yellow
    user_input = gets.chomp
    case user_input
    when '1'
      guess_letter
    when '2'
      guess_word
    when '3'
      save_game
    else
      puts "Invalid input, try again\n".red
      letter_or_word
    end
  end

  def guess_letter
    puts "\nGuess a letter:".yellow
    user_input = gets.chomp.downcase
    if /[a-z]/.match?(user_input) == false || user_input.length > 1
      puts 'Invalid input, try again'.red
      return guess_letter
    elsif @letters_guessed.include?(user_input)
      puts "You've already guessed #{user_input}, try again".red
      return guess_letter
    end
    @letters_guessed.push(user_input)
    user_input
  end

  def guess_word
    puts "\nGuess the word:".yellow
    user_input = gets.chomp.downcase
    if user_input.length != @word.length
      puts 'Invalid word length, try again'.red
      return guess_word
    end
    user_input
  end

  def check_letter(letter)
    @word.chars.each_with_index do |char, index|
      if letter == char
        @board.update_board(letter, index)
      end
    end
  end

  def check_word(word)
    if word == @word
      @game_over = true
      word.chars.each_with_index { |char, index| @board.update_board(char, index) }
    else
      puts 'That was not the correct word'
    end
  end

  def save_game
    current_state = { 'word': @word, 'board': @board.game_board, 'guess_count': @guess_count, 'letters_guessed': @letters_guessed, 'game_over': @game_over }
    File.open("saves/save_#{Time.now}.json", 'w') do |f|
      f.write(current_state.to_json)
    end
    puts 'saved the game!'
    exit
  end

end
