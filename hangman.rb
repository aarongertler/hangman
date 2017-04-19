# You should also display which correct letters have already been chosen 
# (and their position in the word, e.g. _ r o g r a _ _ i n g) 
# and which incorrect letters have already been chosen.
# Every turn, allow the player to make a guess of a letter. It should be case insensitive. Update the display to reflect whether the letter was correct or incorrect. If out of guesses, the player should lose.
# Now implement the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Remember what you learned about serializing objects... you can serialize your game class too!
# When the program first loads, add in an option that allows you to open one of your saved games, which should jump you exactly back to where you were when you saved. Play on!

require 'yaml/store'
require './lib/helper.rb'
require './lib/game.rb'
require './lib/display.rb'

choice = ""

# Methods

def prompt
  puts 'To start a new game, enter "new".'
  puts 'To load an old game, enter "load".'
end

def mode_select
  puts 'To play in easy mode, enter "easy".'
  puts 'To play in hard mode, enter "hard".'
  gets.chomp.downcase
end

def play_again_offer
  puts 'Would you like to play again? Enter "yes" or "no".'
  choice = gets.chomp.downcase
  if choice.downcase == "yes"
    mode = mode_select
    Game.new(mode).play_game
  end
end

# Flow

until choice.downcase == "new" || choice.downcase == "load"
  prompt
  choice = gets.chomp
end

if choice.downcase == "new"
  mode = mode_select
  Game.new(mode).play_game
elsif choice.downcase == "load"
  directory = "./saved_games"
  puts Dir.glob('#{directory}.{store}').join(",\n")
  # Dir.glob(directory).length.times do |i|
  #   puts "Game #{i}: "
  # List all files from the saved game folder with a number
  # Load whichever game matches the number the player gives
end

play_again_offer
