import random

# Does not compile due to a silly indentation issue
# Fails to display whether the guess is higher or lower
# guess = 0 is sometimes incorrect if target_number is 0 (1/19th)
#
#
# Suggestion to be annoying:
# ask for help. Once the issue with the indentation is fixed, asked to be
# signed off immediately without testing anything
# 
# Delete this comment before interacting with the TA

def game(target_number):
    guess = 0
    while guess != target_number:
            guess = int(input("Enter your guess: "))
        if guess != target_number:
                print("your guess is wrong")

# Main program
game(random.randint(-10, 10))
print("u win")
