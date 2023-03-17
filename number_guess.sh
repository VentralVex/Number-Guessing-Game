#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

read -p "Enter your username:" USERNAME

USERNAME_EXISTS=$($PSQL "SELECT username FROM games WHERE username='$USERNAME'")
GAME_COUNT=$($PSQL "SELECT COUNT(*) FROM games WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE username='$USERNAME'")
#if user exists
if [[ -n $USERNAME_EXISTS ]]; then
  echo "Welcome back, $USERNAME! You have played $GAME_COUNT games, and your best game took $BEST_GAME guesses."
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

# Generate a random number between 1 and 1000
NUM=$((1 + RANDOM % 1000))

# Initialize the guess count to 0
guesses=0

# Loop until the user guesses the NUM number
while true; do
    # Prompt the user for a guess
    read -p "Guess the secret number between 1 and 1000: " guess

    # Check if the guess is an integer
    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        continue
    fi

    # Increment the guess count
    guesses=$((guesses + 1))

    # Check if the guess is correct
    if ((guess == NUM)); then
        echo "You guessed it in $guesses tries. The secret number was $NUM. Nice job!"
        $PSQL "INSERT INTO games(username, guesses) VALUES('$USERNAME', $guesses)"
        break
    elif ((guess < NUM)); then
        echo "It's higher than that, guess again:"
    else
        echo "It's lower than that, guess again:"
    fi
done
