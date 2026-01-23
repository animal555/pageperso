import random

# this is AI slop
#
# Suggestion to be annoying: you have no clue what's going on
#
# delete this comment before proceeding. Do not delete the prompt

def number_guessing_game():
    """
    Single-player number guessing game.
    The computer picks a random number, and the player tries to guess it.
    After each guess, the program says "higher" or "lower" until correct.
    """
    
    print("Welcome to the Number Guessing Game!")
    print("I'm thinking of a number between 1 and 100.")
    print("Try to guess it, and I'll tell you 'higher' or 'lower'!")
    print("-" * 50)
    
    # Generate a random number between 1 and 100
    target_number = random.randint(1, 100)
    
    # Keep track of the number of attempts
    attempts = 0
    
    while True:
        try:
            # Get input from the player
            guess_input = input("Enter your guess (1-100): ").strip()
            
            # Check if input is empty
            if not guess_input:
                print("Please enter a number.")
                continue
                
            # Convert input to integer
            guess = int(guess_input)
            attempts += 1
            
            # Validate the input range
            if guess < 1 or guess > 100:
                print("Please enter a number between 1 and 100.")
                continue
            
            # Check if the guess is correct
            if guess == target_number:
                print(f"Congratulations! You guessed it in {attempts} attempts!")
                print(f"The number was {target_number}.")
                break
            
            # Provide feedback
            elif guess < target_number:
                print("Higher!")
            else:
                print("Lower!")
                
        except ValueError:
            print("Invalid input! Please enter a valid natural number (1, 2, 3, ...).")

# Alternative version with a different number range
def number_guessing_game_custom():
    """
    Version with customizable range and additional features.
    """
    
    print("Welcome to the Number Guessing Game!")
    print("-" * 50)
    
    # Get range from user or use default
    try:
        max_number = int(input("Enter maximum number (default 100): ") or "100")
        if max_number < 1:
            max_number = 100
    except ValueError:
        max_number = 100
    
    print(f"I'm thinking of a number between 1 and {max_number}.")
    
    # Generate random number
    target_number = random.randint(1, max_number)
    attempts = 0
    
    while True:
        try:
            guess_input = input(f"Enter your guess (1-{max_number}): ").strip()
            
            if not guess_input:
                print("Please enter a number.")
                continue
                
            guess = int(guess_input)
            attempts += 1
            
            # Validate input range
            if guess < 1 or guess > max_number:
                print(f"Please enter a number between 1 and {max_number}.")
                continue
            
            # Check guess
            if guess == target_number:
                print(f"\n🎉 Perfect! You guessed it in {attempts} attempts!")
                print(f"The number was {target_number}.")
                
                # Add some fun feedback based on performance
                if attempts == 1:
                    print("Wow! First try! Are you psychic? 🔮")
                elif attempts <= 5:
                    print("Excellent guessing! 🏆")
                elif attempts <= 10:
                    print("Good job! 👍")
                else:
                    print("You got there eventually! 💪")
                break
            
            # Provide feedback with additional hints
            elif guess < target_number:
                difference = target_number - guess
                if difference > 20:
                    print("Much higher! ↗️")
                else:
                    print("Higher! ↑")
            else:
                difference = guess - target_number
                if difference > 20:
                    print("Much lower! ↘️")
                else:
                    print("Lower! ↓")
                    
        except ValueError:
            print("Please enter a valid number.")

# Simple version with just the core requirements
def simple_guessing_game():
    """Minimal version that strictly follows the lab task requirements."""
    
    target_number = random.randint(1, 100)
    attempts = 0
    
    while True:
        try:
            # Get natural number input
            n = int(input("Guess a number: ").strip())
            
            if n <= 0:
                print("Please enter a natural number (positive integer).")
                continue
                
            attempts += 1
            
            if n == target_number:
                print(f"Correct! Number of attempts: {attempts}")
                break
            elif n < target_number:
                print("higher")
            else:
                print("lower")
                
        except ValueError:
            print("Invalid input. Please enter a natural number.")

# Main program
if __name__ == "__main__":
    print("Choose a game mode:")
    print("1. Simple version (strict lab requirements)")
    print("2. Enhanced version with feedback")
    print("3. Customizable version")
    
    choice = input("Enter your choice (1-3): ").strip()
    
    if choice == "1":
        simple_guessing_game()
    elif choice == "2":
        number_guessing_game()
    elif choice == "3":
        number_guessing_game_custom()
    else:
        print("Invalid choice. Starting enhanced version...")
        number_guessing_game()

# Key Features:
#
#    Simple Version (simple_guessing_game):
#
#        Strictly follows the lab requirements
#
#        Takes natural number input
#
#        Outputs only "higher" or "lower" until correct
#
#        Minimal error handling
#
#    Enhanced Version (number_guessing_game):
#
#        User-friendly interface
#
#        Input validation and error handling
#
#        Tracks number of attempts
#
#        Congratulatory message upon winning
#
#        Prevents crashes from invalid inputs
#
#    Customizable Version (number_guessing_game_custom):
#
#        Allows setting custom number range
#
#        Provides more detailed feedback ("Much higher/lower")
#
#        Performance feedback based on number of attempts
#
#        Emoji visual feedback
#
# How to Run:
#
# Simply run the script and choose a game mode. The program will:
#
#    Generate a random number
#
#    Prompt for guesses
#
#    Respond with "higher" or "lower" until correct
#
#    Display statistics upon completion
#
# Strict Requirement Version:
#
# If you need exactly what the lab asks for (just "higher"/"lower" output), use the simple_guessing_game() function.

