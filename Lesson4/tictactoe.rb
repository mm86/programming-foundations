require 'pry'

PLAY_AGAIN_VALID_CHOICES = %w(y n yes no).freeze
PLAY_AGAIN_CHOICES_NO = %w(no n).freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]] # diagonals
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
WHO_STARTS_FIRST = 'choose'.freeze
WINNING_SCORE = 5

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You are a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(input_array, delimiter=",", word="or")
  case input_array.size
  when 1
    input_array.first
  when 2
    input_array.join(" #{word} ")
  else
    input_array[input_array.size - 1] = "#{word} " + input_array.last.to_s
    input_array.join("#{delimiter} ")
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}): "
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  brd[square] = PLAYER_MARKER
end

def get_empty_square(brd, line)
  result = -1
  line.each do |data|
    if brd[data] == INITIAL_MARKER
      result = data
      break
    end
  end
  result
end

def check_for_two_computer_marker(brd)
  result = -1
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2
      result = get_empty_square(brd, line)
      break
    end
  end
  result
end

def check_for_two_player_marker(brd)
  result = -1
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2
      result = get_empty_square(brd, line)
      break
    end
  end
  result
end

def find_at_risk_square(brd)
  if check_for_two_computer_marker(brd) != -1
    check_for_two_computer_marker(brd)
  elsif check_for_two_player_marker(brd) != -1
    check_for_two_player_marker(brd)
  end
end

def computer_places_piece!(brd)
  square = if (1..9).member?(find_at_risk_square(brd))
             find_at_risk_square(brd)
           elsif brd[5] == " "
             5
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def ask_to_play_again
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

def reset_points
  points[:player] = 0
  points[:computer] = 0
end

def update_points(points, brd)
  case detect_winner(brd)
  when 'Player'
    points[:player] += 1
  when 'Computer'
    points[:computer] += 1
  else
    points[:player] += 1
    points[:computer] += 1
  end
end

def place_piece!(brd, current_player)
  if current_player == 'player'
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def alternate_player(current_player)
  current_player == 'player' ? 'computer' : 'player'
end

def who_plays_first?
  prompt "Who should start first? Enter computer or player"
  player_first = gets.chomp
  player_first == 'player' ? 'player' : 'computer'
end

def display_win_condition?
  loop do
    prompt "To win the game, you must get 5 points."
    prompt "To continue playing the game, press enter"
    enter = gets.chomp
    if enter != ""
      prompt "Invalid choice. Please press the enter button"
    else
      break
    end
  end
end

def display_winner(points)
  if points[:computer] == WINNING_SCORE && points[:player] == WINNING_SCORE
    prompt "It's a tie between player and the computer"
  elsif points[:computer] == WINNING_SCORE
    prompt "Computer won the game"
  elsif points[:player] == WINNING_SCORE
    prompt "player won the game"
  end
end

points = { player: 0, computer: 0 }

current_player = who_plays_first?

loop do
  board = initialize_board

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie"
  end

  update_points(points, board)

  if points[:player] == WINNING_SCORE || points[:computer] == WINNING_SCORE
    display_winner(points)
    play_again_response = ask_to_play_again
    if play_again_response.start_with?('y')
      reset_points(points)
    end
    break if PLAY_AGAIN_CHOICES_NO.include?(play_again_response.downcase)
    current_player = who_plays_first?
  end

  prompt "Player score is: #{points[:player]}."
  prompt "Computer score is: #{points[:computer]}."

  display_win_condition?
end

prompt "Thanks for playing the game tic tac toe"
