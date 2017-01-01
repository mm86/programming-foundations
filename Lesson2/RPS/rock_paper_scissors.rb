VALID_CHOICES = %w(rock paper scissors lizard spock)
PLAY_AGAIN_VALID_CHOICES = %w(y n yes no)
PLAY_AGAIN_CHOICES_NO = %w(no n)
WINNING_SCORE = 5

def prompt(message)
  puts("=> #{message}")
end

def check_valid_answer
  loop do
    prompt("Do you want to play again?")
    answer = gets.chomp
    if PLAY_AGAIN_VALID_CHOICES.include?(answer.downcase)
      return answer
    else
      prompt("Please enter y/n/yes/no")
    end
  end
end

WINNING_COMBOS = {
  'rock' => %w(scissors lizard),
  'paper' => %w(rock spock),
  'scissors' => %w(paper lizard),
  'spock' => %w(rock scissors),
  'lizard' => %w(spock paper)
}

def win?(first, second)
  WINNING_COMBOS[first].include?(second)
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
  [player_points, computer_points]
end

player_points = 0
computer_points = 0

loop do
  player_choice = ''
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
    player_choice = gets.chomp.downcase

    if player_choice == 'r'
      player_choice = 'rock'
    elsif player_choice == 'sc'
      player_choice = 'scissors'
    elsif player_choice == 'l'
      player_choice = 'lizard'
    elsif player_choice == 'sp'
      player_choice = 'spock'
    elsif player_choice == 'p'
      player_choice = 'paper'
    end

    if VALID_CHOICES.include?(player_choice)
      break
    else
      prompt('That\'s not a valid choice.')
    end
  end

  computer_choice = VALID_CHOICES.sample
  prompt("You chose: #{player_choice}; Computer chose: #{computer_choice}")

  points = calculate_results(player_choice,
                             computer_choice,
                             player_points,
                             computer_points)
  player_points = points[0]
  computer_points = points[1]
  prompt("Your points: #{player_points}; Computer points: #{computer_points}")

  if (player_points == WINNING_SCORE) && (computer_points == WINNING_SCORE)
    prompt('It\'s a tie')
    player_points = 0
    computer_points = 0
    play_again_response = check_valid_answer
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  elsif computer_points == WINNING_SCORE
    prompt('Computer Wins')
    player_points = 0
    computer_points = 0
    play_again_response = check_valid_answer
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  elsif player_points == WINNING_SCORE
    prompt("Player Wins")
    player_points = 0
    computer_points = 0
    play_again_response = check_valid_answer
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
  end
end

prompt("Thanks for playing the game")
