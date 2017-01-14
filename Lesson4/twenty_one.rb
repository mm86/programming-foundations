
BUSTED_SCORE = 21
DEALER_SCORE_LIMIT = 17
WINNING_SCORE = 5
SPACER = "==============================".freeze

SUITS = ['H', 'D', 'S', 'C'].freeze
VALUES = ['2', '3', '4', '5', '6', '7', '8'] +
         ['9', '10', 'J', 'Q', 'K', 'A'].freeze

def prompt(msg)
  puts "=> #{msg}"
end

def reset_points(points)
  points[:player_points] = 0
  points[:dealer_points] = 0
end

def play_again?(points)
  prompt SPACER
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  prompt SPACER

  user_response = answer.downcase.start_with?('y')
  reset_points(points) if user_response == true
  user_response
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def calculate_ace_value(total)
  total + 11 > BUSTED_SCORE ? 1 : 11
end

def calculate_total(cards)
  values = cards.map { |card| card[1] }
  total = 0
  values.each do |value|
    if value =~ /[0-9]/
      total += value.to_i
    elsif value =~ /['JQK']/
      total += 10
    elsif value =~ /['A']/
      total += calculate_ace_value(total)
    end
  end
  total
end

def busted?(cards)
  calculate_total(cards) > BUSTED_SCORE
end

def compute_result(player, dealer)
  player_total = calculate_total(player)
  dealer_total = calculate_total(dealer)

  if player_total > 21
    [:player_busted, :player]
  elsif dealer_total > 21
    [:dealer_busted, :dealer]
  elsif dealer_total < player_total
    [:player_won, :player]
  elsif dealer_total > player_total
    [:dealer_won, :dealer]
  else
    [:tie, :both]
  end
end

def display_final_cards_total(player, dealer)
  prompt "Player cards: #{player}"
  prompt "Player total: #{calculate_total(player)}"
  prompt "Dealer cards: #{dealer}"
  prompt "Dealer total: #{calculate_total(dealer)}"
  prompt SPACER
end

def display_result(dealer_cards, player_cards, points)
  prompt "===========RESULT============"
  result = compute_result(dealer_cards, player_cards)
  case result[0]
  when :player_busted
    prompt "Player busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player_won
    prompt "You win! Dealer loses"
  when :dealer_won
    prompt "Dealer wins! You lose"
  when :tie
    prompt "It's a tie!"
  end
  update_points(points, result[1])
  display_final_cards_total(player_cards, dealer_cards)
  prompt "============================="
end

def update_points(points, person)
  if person == :player
    points[:player_points] += 1
  elsif person == :dealer
    points[:dealer_points] += 1
  else
    points[:player_points] += 1
    points[:dealer_points] += 1
  end
end

def welcome_message
  prompt SPACER
  prompt "Welcome to Twenty-One Game"
  prompt "To win this game, one of you must score 5 points."
  prompt SPACER
end

def display_winner(points)
  if points.values.all? { |value| value == 5 }
    prompt "GAME WINNER: It's a tie between player and dealer."
  elsif points[:player_points] == WINNING_SCORE
    prompt "GAME WINNER: Player won with 5 points"
  elsif points[:dealer_points] == WINNING_SCORE
    prompt "GAME WINNER: Dealer won with 5 points"
  end
end

points = { player_points: 0, dealer_points: 0 }

welcome_message

loop do
  deck = initialize_deck

  player_cards = []
  dealer_cards = []

  player_cards << deck.pop << deck.pop
  dealer_cards << deck.pop << deck.pop

  prompt "Dealer Cards: #{dealer_cards[0]} and ?"
  prompt "Player Cards: #{player_cards[0]} and #{player_cards[1]}"
  prompt "Player Total: #{calculate_total(player_cards)}"
  prompt "============SCORE============="
  prompt "Player: #{points[:player_points]}"
  prompt "Dealer: #{points[:dealer_points]}"
  prompt SPACER

  answer = nil
  loop do
    puts "Player: Hit(h) or Stay(s)?"
    answer = gets.chomp.downcase
    if answer == 'h'
      player_cards << deck.pop
      prompt "Player Cards: #{player_cards}"
      prompt "Player Total: #{calculate_total(player_cards)}"
    end
    break if answer == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(player_cards, dealer_cards, points)
    next if points.values.any? { |value| value == 5 }
  else
    prompt "Player chose to stay!"
  end

  dealer_total = calculate_total(dealer_cards)
  prompt "Dealer turn...."
  prompt "Dealer Cards: #{dealer_cards}"
  prompt "Dealer Total: #{dealer_total}"

  loop do
    break if busted?(dealer_cards) || dealer_total >= DEALER_SCORE_LIMIT
    prompt "Dealer hits"
    dealer_cards << deck.pop
    dealer_total = calculate_total(dealer_cards)
    prompt "Dealer Cards: #{dealer_cards}"
    prompt "Dealer Total:  #{dealer_total}"
  end

  if !busted?(dealer_cards)
    prompt "Dealer stays at #{dealer_total}"
  end

  display_result(player_cards, dealer_cards, points)

  if points.values.any? { |value| value == 5 }
    display_winner(points)
    break unless play_again?(points)
  end
end

prompt "Thanks for playing 21 game"
