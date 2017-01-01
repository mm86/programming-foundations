VALID_CHOICES = %w(rock paper scissors lizard spock)
PLAY_AGAIN_CHOICES = %w(y n yes no)
PLAY_AGAIN_CHOICES_NO = %w(no n)
WINNING_SCORE = 5

def prompt(message)
  puts("=> #{message}")
end

def check_valid_answer
  loop do
    prompt("Do you want to play again?")
    answer = gets.chomp
    if PLAY_AGAIN_CHOICES.include?(answer.downcase)
      return answer
    else
      prompt("Please enter y/n/yes/no")
    end
  end
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'scissors' && second == 'paper') ||
    (first == 'rock' && second == 'lizard') ||
    (first == 'lizard' && second == 'spock') ||
    (first == 'spock' && second == 'scissors') ||
    (first == 'scissors' && second == 'lizard') ||
    (first == 'lizard' && second == 'paper') ||
    (first == 'paper' && second == 'spock') ||
    (first == 'spock' && second == 'rock')
end

def calculate_results(player, computer, player_points, computer_points)
  if win?(player, computer)
    player_points += 1
  elsif win?(computer, player)
    computer_points += 1
  else
    player_points += 1
    computer_points += 1
  end
  return player_points, computer_points
end

player_count = 0
computer_count = 0

loop do
  choice = ''
  loop do
    operator_prompt = <<-MSG
      Choose one from the following?
      1). r/R for rock
      2). sc/SC for scissors
      3). p/P for paper
      4). l/L for lizard
      5). sp/SP for spock
    MSG

    prompt(operator_prompt)
    choice = gets.chomp

    if choice == 'R' || choice == 'r'
      choice = 'rock'
    elsif choice == 'SC' || choice == 'sc'
      choice = 'scissors'
    elsif choice == 'L' || choice == 'l'
      choice = 'lizard'
    elsif choice == 'SP' || choice == 'sp'
      choice = 'spock'
    elsif choice == 'P' || choice == 'p'
      choice = 'paper'
    end

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt('That\'s not a valid choice.')
    end
  end

  computer_choice = VALID_CHOICES.sample
  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

  player_points, computer_points = calculate_results(choice, computer_choice, player_count, computer_count)
  player_count = player_points
  computer_count = computer_points

  prompt("Your points: #{player_points}; Computer points: #{computer_points}")

  if (player_points == WINNING_SCORE) && (computer_points == WINNING_SCORE)
    prompt('It\'s a tie')
    player_count = 0
    computer_count = 0
    play_again_response = check_valid_answer
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  elsif computer_points == WINNING_SCORE
    prompt('Computer Wins')
    player_count = 0
    computer_count = 0
    play_again_response = check_valid_answer
    break PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  elsif player_points == WINNING_SCORE
    prompt("Player Wins")
    player_count = 0
    computer_count = 0
    play_again_response = check_valid_answer
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  end
end

prompt("Thanks for playing the game")
