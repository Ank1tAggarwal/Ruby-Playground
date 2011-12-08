MAX_NUMBER = 100
MIN_NUMBER = 1
MAX_GUESS = 10

puts "Hello player. What is your name?"
name = gets
name = name.chomp
puts "Hello #{name}. I'm guessing a number between #{MIN_NUMBER} and #{MAX_NUMBER}."
puts "You need to guess the number. I will tell you if you are too low or too high. You have a maximum of #{MAX_GUESS} guesses."


# Keep the games running in a bigger loop. If the user asks to stop playing, then we break out of this outer/main loop.
loop do
  
  #This needs to appear at the beginning of each game, INSIDE the outer game loop. Otherwise it will be the same number every time!
  computers_number = rand(MAX_NUMBER - MIN_NUMBER + 1) + MIN_NUMBER

  start = Time.now # Start the timer for measuring the length of time it takes the user to guess the right answer. 
  # You don't want to declare this inside the loop below because then every time you make a guess, the start timer will be recalculated.
  
  # Start the game
  1.upto(MAX_GUESS) do |number|

    puts "What's your guess?"
    
    guess = gets.chomp
    if guess == "clue"
      # Can retrieve the clue in multiple ways. Here are a couple:
      # computers_number.to_s.split("").to_a.last
      # computers_number.to_s[-1]
      clue = computers_number % 10      
      puts "Here's a clue. The number I'm thinking of ends with the following digit: #{clue}."
    else 
      guess = guess.to_i
      puts "Your guess was too low! Try again!" if guess < computers_number
      puts "Your guess was too high! Try again!" if guess > computers_number
      if guess == computers_number
        elapsed = Time.now - start
        puts "You got the number right! It was #{computers_number}. It took you #{elapsed} seconds to figure it out."
        break
      end
    end
    
    puts "Sorry, that was the maximum number of guesses!" if number == MAX_GUESS

  end # End the game
  
  # Ask the user if he wants to play another game
  puts "Would you like to play again? Type \"Y\" or \"N\"."
  answer = "Y" # We HAVE to declare the variable OUTSIDE of the code block below, because otherwise we cannot refer to it again outside of the code block and outside of that loop (i.e. the variable only exists inside of the loop if declared inside)
  
  # Keep asking the user until you recognize the proper response
  loop do
    answer = gets.chomp # Must make sure to 'chomp' the result, otherwise we won't get an exact match to 'Y' or 'N'
    break if answer == "N" || answer == "Y"
    puts "Sorry, but did not recognize your response. Please type \"Y\" or \"N\"."
  end

  # If the user's answer is "N" then break out of the bigger loop and exit. Otherwise, the loop will run the game again.
  break if answer == "N"
  
end