# Car Loan Monthly Mortgage calculator

require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

# methods
def prompt(input)
  puts("=> #{input}")
end

def valid_number?(input)
  integer?(input) || float?(input)
end

def integer?(input)
  /^\d+$/.match(input)
end

def float?(input)
  /\d/.match(input) && /^\d*\.?\d*$/.match(input)
end

# Welcome message
prompt(MESSAGES['welcome'])
# main loop
loop do
  # Get the loan amount, annual percent rate and loan duration values from the user
  loan_amount = ''
  loop do
    prompt(MESSAGES['loan_amount'])
    loan_amount = gets.chomp
    if valid_number?(loan_amount)
      break
    else
      prompt(MESSAGES['validation_error'])
    end
  end

  annual_percent_rate = ''
  loop do
    prompt(MESSAGES['annual_rate'])
    annual_percent_rate = gets.chomp
    if valid_number?(annual_percent_rate)
      break
    else
      prompt(MESSAGES['validation_error'])
    end
  end

  loan_duration = ''
  loop do
    prompt(MESSAGES['loan_duration'])
    loan_duration = gets.chomp
    if valid_number?(loan_duration)
      break
    else
      prompt(MESSAGES['validation_error'])
    end
  end

  # calculate monthly interest rate from the annual percentage rate

  monthly_interest = (annual_percent_rate.to_f / 100) / 12

  # calculate the car mortgage per month using the following formula
  # m = p * (j / (1 - (1 + j)**(-n)))

  mortgage = loan_amount.to_i * (monthly_interest / (1 - (1 + monthly_interest)**-loan_duration.to_i))
  prompt("Your mortgage every month is $#{mortgage}")

  # Want to perform another round of calculations?
  prompt(MESSAGES['play_again'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
