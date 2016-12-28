VALID_CHOICES = %w(rock paper scissors lizard spock)

def prompt(message)
  puts("=> #{message}")
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

def calculate_results(player, computer, player_c, computer_c)
  player_points = player_c
  computer_points = computer_c

  if win?(player, computer)
    player_points += 1
    player_c += 1
  elsif win?(computer, player)
    computer_points += 1
    computer_c += 1
  else
    player_points += 1
    computer_points += 1
    player_c += 1
    computer_c += 1
  end
  return player_points, computer_points, player_c, computer_c
end

player_count = 0
computer_count = 0

loop do
  choice = ''
  loop do
    prompt("Choose one: 'r for rock', 'sc for scissors', 'p for paper', 'l for lizard', 'sp for spock'")
    choice = gets.chomp

    case choice
    when 'r'
      choice = 'rock'
    when 'sc'
      choice = 'scissors'
    when 'l'
      choice = 'lizard'
    when 'sp'
      choice = 'spock'
    when 'p'
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

  player_points, computer_points, updated_player_count, updated_computer_count = calculate_results(choice, computer_choice, player_count, computer_count)
  player_count = updated_player_count
  computer_count = updated_computer_count

  prompt("Your points: #{player_points}; Computer points: #{computer_points}")

  if player_points == 5
    prompt('player wins')
  elsif computer_points == 5
    prompt('computer wins')
  elsif (player_points == 5) && (computer_points == 5)
    prompt("It's a tie")
  end

  if (player_points == 5) || (computer_points == 5)
    prompt('Do you want to play again?')
    answer = gets.chomp
    break unless answer.downcase.start_with?('y')
  end
end

prompt('Thanks for playing the game')
