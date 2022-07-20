require_relative 'board'
require 'colorize'

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

    while @guess_count < 6 && @game_over == false
      puts "\nGuess Count: ".green + @guess_count.to_s + '   Remaining Guesses: '.green + (6 - @guess_count).to_s
      puts 'Letters that have been guessed: '.green + "#{@letters_guessed}\n"
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
        puts "\nYou've found all the letters of the word!".green
        @game_over = true
      end
    end
    @board.game_board.each { |element| print element }
    puts "\n\n"
    return if @game_over == true

    puts 'You were unable to correctly guess it in 6 tries :(. The word was: ' + @word.to_s.green
  end

  def letter_or_word
    puts 'Input "1" to guess letter, input "2" to guess the word:'.yellow
    user_input = gets.chomp
    case user_input
    when '1'
      guess_letter
    when '2'
      guess_word
    else
      puts 'Invalid input, try again'.red
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
      guess_word
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
      puts 'You correctly guessed the word!'.green
      @game_over = true
    else
      puts 'That was not the correct word'.orange
    end
  end

end
