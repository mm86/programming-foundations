
BUSTED_SCORE = 21

SUITS = ['H', 'D', 'S', 'C'].freeze
VALUES = ['2', '3', '4', '5', '6', '7', '8'] +
         ['9', '10', 'J', 'Q', 'K', 'A'].freeze

def prompt(msg)
  puts "=> #{msg}"
end

def play_again?
  puts "====================================="
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def initialize_deck
  SUITS.product(VALUES).shuffle
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
      total + 11 < BUSTED_SCORE ? total += 11 : total += 1
    end
  end
  total
end

def busted?(cards)
  calculate_total(cards) > BUSTED_SCORE
end

def display_winner(player, dealer)
  prompt "==============="
  if calculate_total(player) > calculate_total(dealer)
    prompt "Player won with #{player}"
    prompt "Player total is #{calculate_total(player)}"
    prompt "Dealer loses with #{dealer}"
    prompt "Dealer total is #{calculate_total(dealer)}"
  else
    prompt "Dealer won with #{dealer}"
    prompt "Dealer total is #{calculate_total(dealer)}"
    prompt "Player loses with #{player}"
    prompt "Player total is #{calculate_total(player)}"
  end
  prompt "==============="
end

# main game starts here
loop do
  prompt "Welcome to Twenty-One"
  player = []
  dealer = []

  deck = initialize_deck
  player << deck.pop << deck.pop
  dealer << deck.pop << deck.pop

  prompt "Dealer's cards are #{dealer[0]} and ?"
  prompt "Player's cards are #{player[0]} and #{player[1]}"
  prompt "Player total is #{calculate_total(player)}"

  answer = nil
  loop do
    puts "Player: Hit(h) or Stay(s)?"
    answer = gets.chomp.downcase
    if answer == 'h'
      player << deck.pop
      prompt "Player cards are #{player}"
      prompt "Player total score is #{calculate_total(player)}"
    end
    # break if any one of them is true
    break if answer == 's' || busted?(player)
  end

  if busted?(player)
    prompt "Player busted. Dealer wins."
    display_winner(player, dealer)
    break
  else
    prompt "Player chose to stay!"
  end

  # dealer turn

  prompt "Dealer turn"
  prompt "Dealer's cards are #{dealer}"
  prompt "Dealer total is #{calculate_total(dealer)}"

  loop do
    break if busted?(dealer) || calculate_total(dealer) >= 17
    prompt "Dealer hits"
    dealer << deck.pop
    prompt "Dealer's cards are #{dealer}"
    prompt "Dealer total is #{calculate_total(dealer)}"
  end

  if busted?(dealer)
    prompt "Dealer busted. Player wins"
    break unless play_again?
  else
    prompt "Dealer stays at #{calculate_total(dealer)}"
    display_winner(player, dealer)
  end

  break unless play_again?
end

prompt "Thanks for playing 21 game"
