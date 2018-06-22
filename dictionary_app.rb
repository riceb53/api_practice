# Build a terminal dictionary app
# Create a new ruby file called dictionary_app.rb
# The program should ask the user to enter a word, then use the wordnik API to show the word’s definition, top example, and pronunciation: http://developer.wordnik.com/docs.html#!/word
# Bonus: Write your program in a loop such that the user can keep entering new words without having to restart the program. Give them the option of entering q to quit.

require 'unirest.rb'

while true

  # get user input, downcases it to avoid errors
  puts "Enter a word to search for.  Type in q to quit."
  word = gets.downcase.chomp
  
  # creates an option to quit the program so it is not endless
  if word == "q"
    system "clear"
    puts "Goodbye!!!!"
    break
  end
  
  #clears the screen here
  system "clear"

  # gets JSON data
  definition_response = Unirest.get("https://api.wordnik.com/v4/word.json/#{word}/definitions?limit=200&includeRelated=false&useCanonical=false&includeTags=false&api_key=apikey")
  top_example_response = Unirest.get"https://api.wordnik.com/v4/word.json/#{word}/topExample?useCanonical=false&api_key=apikey"
  all_pronunciations = Unirest.get"https://api.wordnik.com/v4/word.json/#{word}/pronunciations?useCanonical=false&limit=50&api_key=apikey"

  #check for nonsensical words
  if definition_response.body[0] == nil
    puts "Invalid word"
    next
  end

  # Below were a few JSON tests
  #----------------------------
    # puts JSON.pretty_generate(definition_response.body)
    # puts JSON.pretty_generate(top_example_response.body)
    # puts JSON.pretty_generate(all_pronunciations.body)

  # method to print definitions from JSON, didn't need to be a method I suppose.  I wanted to separate all variables and methods from screen output was my thought process.
  def definitions(input)
    list = 1
    input.body.each do |definition|
      current_definition = definition['text']
      puts "#{list}. #{current_definition}"
      list += 1
    end
  end

  # gets best example from JSON
  top_example = top_example_response.body['text']

  # method to pring pronunciations from JSON, didn't need a method here either but I felt like using a method
  def pronunciations(input)
    list = 1
    input.body.each do |pronuciation|
      current_pronunciation = pronuciation['raw']
      puts "#{list}. #{current_pronunciation}"
      list += 1
    end
  end

  # output for terminal, uses dashes for cleaner screen
  puts "-" * 20
  puts "You entered #{word}."
  `say #{word}`
  puts "-" * 20
  puts "We found the following definitions:"
  definitions(definition_response)
  puts "-" * 20
  puts "The best example usage is:"
  puts top_example
  puts "-" * 20
  puts "We found the following pronunciations:"
  pronunciations(all_pronunciations)
  puts "-" * 20

end