BUSTED_SCORE = 21
DEALER_SCORE_LIMIT = 17
WINNING_SCORE = 5
SPACER = "==============================".freeze

SUITS = %w(H D S C).freeze
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A).freeze

def prompt(msg)
  puts "=> #{msg}"
end

def reset_points(points)
  points[:player_points] = 0
  points[:dealer_points] = 0
end

def play_again?(points)
  prompt SPACER
  answer = nil
  loop do
    prompt "Do you want to play again? (y or n)"
    answer = gets.chomp
    break if ['y', 'n'].include?(answer)
    prompt "Please enter a valid response. y or n"
  end
  prompt SPACER

  user_response = answer.downcase.start_with?('y')
  reset_points(points) if user_response
  user_response
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  values = cards.map { |card| card[1] }
  total = 0
  values.each do |value|
    if value =~ /[0-9]/
      total += value.to_i
    elsif value =~ /['JQK']/
      total += 10
    elsif value =~ /['A']/
      total += 11
    end
  end

  values.select { |value| value == "A" }.count.times do
    total -= 10 if total > 21
  end
  total
end

def busted?(cards)
  total(cards) > BUSTED_SCORE
end

def compute_result(player, dealer)
  player_total = total(player)
  dealer_total = total(dealer)

  if player_total > 21
    [:player_busted, :dealer]
  elsif dealer_total > 21
    [:dealer_busted, :player]
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
  prompt "Player total: #{total(player)}"
  prompt "Dealer cards: #{dealer}"
  prompt "Dealer total: #{total(dealer)}"
  prompt SPACER
end

def display_result(player_cards, dealer_cards, points)
  prompt "===========RESULT============"
  result = compute_result(player_cards, dealer_cards)
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
end

def update_points(points, person)
  if person == :player
    points[:player_points] += 1
  elsif person == :dealer
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

def display_initial_cards_and_total(player_cards, dealer_cards, points)
  prompt "============GAME============="
  prompt "Dealer Cards: #{dealer_cards[0]} and ?"
  prompt "Player Cards: #{player_cards[0]} and #{player_cards[1]}"
  prompt "Player Total: #{total(player_cards)}"
  prompt "============SCORE============="
  prompt "Player: #{points[:player_points]}"
  prompt "Dealer: #{points[:dealer_points]}"
  prompt SPACER
end

def player_turn(player_cards, deck)
  loop do
    answer = nil
    loop do
      puts "Player: Hit(h) or Stay(s)?"
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      prompt "Please enter a valid input: h or s"
    end
    if answer == 'h'
      player_cards << deck.pop
      prompt "Player Cards: #{player_cards}"
      prompt "Player Total: #{total(player_cards)}"
    end
    break if answer == 's' || busted?(player_cards)
  end
end

def dealer_turn_starts(dealer_cards)
  prompt "Dealer turn...."
  prompt "Dealer Cards: #{dealer_cards}"
  prompt "Dealer Total: #{total(dealer_cards)}"
end

def dealer_turn(dealer_cards, deck)
  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= DEALER_SCORE_LIMIT
    prompt "Dealer hits"
    dealer_cards << deck.pop
    prompt "Dealer Cards: #{dealer_cards}"
    prompt "Dealer Total:  #{total(dealer_cards)}"
  end
end

points = { player_points: 0, dealer_points: 0 }

welcome_message

loop do
  deck = initialize_deck

  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  display_initial_cards_and_total(player_cards, dealer_cards, points)

  player_turn(player_cards, deck)

  if busted?(player_cards)
    display_result(player_cards, dealer_cards, points)
    if points.values.any? { |value| value == 5 }
      display_winner(points)
      break unless play_again?(points)
    else
      next
    end
  else
    prompt "Player chose to stay!"
  end

  dealer_turn_starts(dealer_cards)

  dealer_turn(dealer_cards, deck)

  if !busted?(dealer_cards)
    prompt "Dealer stays at #{total(dealer_cards)}"
  end

  display_result(player_cards, dealer_cards, points)

  if points.values.any? { |value| value == 5 }
    display_winner(points)
    break unless play_again?(points)
  end
end

prompt "Thanks for playing 21 game"
