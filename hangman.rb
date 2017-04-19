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
  gets.chomp.downcase
end

def select_game
  directory = "saved_games"
  game_array = Dir.glob("#{directory}/*.*").each_with_index.map { |file, i| [i, file]}
  game_array.map { |file| puts "#{file[0]}. #{file[1]}"}
  puts "Choose a number to load a saved game:"
  game_number = gets.chomp.to_i
  return game_array.select { |file| file[0] == game_number }
end

def load_game(file)
  params = Hash.new
  puts "File name: #{file}"
  file = YAML::Store.new(file) # Somehow, this retrieves the old file rather than making a new one (works for me!)
  file.transaction do
    params[:word] = file[:word]
    params[:display] = file[:display]
    params[:chosen_letters] = file[:chosen_letters]
    params[:guesses_allowed] = file[:guesses_allowed]
    params[:guesses_taken] = file[:guesses_taken]
    puts "Parameters of loaded game: #{params}"
  end
  Game.new("load_game", params).play_game
end

def start_game
  choice = prompt until choice == "new" || choice == "load"
  if choice == 'new'
    Game.new("new_game").play_game
  elsif choice == 'load'
    file_to_load = select_game[0][1]
    load_game(file_to_load)
  end
end

def play_again_offer
  puts 'Would you like to play again? Enter "yes" or "no".'
  choice = gets.chomp.downcase
  if choice == "yes"
    start_game
  else
    Helper::exit_game
  end
end

# Flow

start_game

play_again_offer
