class Game
  include Helper

  def initialize(new_or_load, **params)
    # Might make more sense to purge dictionary of newlines rather than chomping
    @dictionary = File.readlines('./dictionary.txt')
    if new_or_load == "load_game"
      params.each do |var, val|
        self.instance_variable_set('@'+var.to_s, val)
      end
    else
      @mode = mode_select
      @word = word_select(@dictionary)
      @display = Display.new(@word.length)
      @chosen_letters = []
      @guesses_allowed = @mode == "hard" ? @word.length + 5 : @word.length + 7
      @guesses = 0
    end
  end

  def mode_select
    puts 'To play in easy mode, enter "easy".'
    puts 'To play in hard mode, enter "hard".'
    gets.chomp.downcase
  end

  def word_select dictionary
    word = ""
    until word.chomp.length.between?(5,12) && /[[:lower:]]/.match(word[0]) # No proper nouns
      word = dictionary.sample
    end
    word.chomp
  end

  def make_guess
    @display.show_horizontal
    show_chosen_letters
    puts "What letter would you like to choose?"
    puts "You can also enter 'save' to save the game, or 'exit' to exit."
    choice = gets.chomp.downcase
    read_choice(choice)
  end

  def show_chosen_letters
    puts "You've chosen the following letters: #{@chosen_letters}"
  end

  def duplicate_letter(letter)
    @chosen_letters.include?(letter)
  end

  def read_choice(choice)
    return evaluate_letter(choice) if choice.length == 1
    save_game if choice == 'save'
    exit_game if choice == 'exit'
    puts "Please enter a letter, 'save', or 'exit'."
  end

  def evaluate_letter(letter)
    if duplicate_letter(letter)
      return puts "You've already chosen this letter!"
    end
    @chosen_letters << letter
    if @word.include?(letter)
      puts "Correct! This word includes the letter #{letter}."
      @display.add_letter_to_display(@word, letter)
    else
      puts "Sorry. This letter is not part of the word."
      @guesses += 1
      puts "You have #{@guesses_allowed - @guesses} more guesses left before you are dead."
    end
  end

  def save_game
    game_time = Time.now.strftime("%m_%d_%Y_%I_%M")
    filename = "./saved_games/#{game_time}.store"
    saved_game = YAML::Store.new(filename)
    saved_game.transaction do
      saved_game[:word] = @word
      saved_game[:display] = @display
      saved_game[:chosen_letters] = @chosen_letters
      saved_game[:guesses_allowed] = @guesses_allowed
      saved_game[:guesses_taken] = @guesses
    end
    puts "Game saved in the following file: #{filename}"
    exit_game
  end

  def word_finished
    !@display.spaces.include?(" __ ")
  end

  def victory_check
    puts "You won! The word was: #{@word}." if word_finished
  end

  def explain_loss
    puts "Sorry, you've run out of guesses. The word was: #{@word}."
  end

  def play_game
    puts "This word is #{@word.length} letters long."
    until @guesses == @guesses_allowed || word_finished
      make_guess
      victory_check
    end
    explain_loss unless word_finished
  end

end




# You don't need to draw an actual stick figure (though you can if you want to!), 
# but do display some sort of count so the player knows how many more incorrect guesses she has before the game ends. 
# You should also display which correct letters have already been chosen (and their position in the word, e.g. _ r o g r a _ _ i n g) 
# and which incorrect letters have already been chosen.
# Every turn, allow the player to make a guess of a letter. It should be case insensitive. Update the display to reflect whether the letter was correct or incorrect. If out of guesses, the player should lose.
# Now implement the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Remember what you learned about serializing objects... you can serialize your game class too!
# When the program first loads, add in an option that allows you to open one of your saved games, which should jump you exactly back to where you were when you saved. Play on!