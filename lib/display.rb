class Display

  attr_reader :spaces

  def initialize(length)
    @spaces = []
    length.to_i.times do |i| 
      @spaces[i] = " __ "
    end
  end

  def show_horizontal
    puts "\n"
    @spaces.each_with_index { |space, i| print @spaces[i] }
    puts "\n\n"
  end

  def add_letter_to_display(word, letter)
    for i in 0...word.length
      @spaces[i] = letter if word[i] == letter
    end
  end

end