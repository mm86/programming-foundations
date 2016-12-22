# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts("=> #{message}")
end

def valid_number?(input)
  integer?(input) || float?(input)
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def operation_to_message(op)
  word = case op
           when '1'
             'Adding'
           when '2'
              'Subtracting'
           when '3'
              'Multiplying'
           when '4'
              'Dividing'
        end
  word
end

prompt(MESSAGES['welcome'])
name = ''
loop do
  name = gets.chomp
  if name.empty?()
    prompt(MESSAGES['valid_name'])
  else
    break
  end
end

prompt("Hi #{name}")
loop do # main loop
  # creates a block of code which means scope of number1 is within the block, is initilaized in this loop
  number1 = ''
  loop do
    prompt(MESSAGES['first_number'])
    number1 = gets.chomp

    if valid_number?(number1)
      break
    else
      prompt(MESSAGES['number_error'])
    end
  end

  number2 = ''
  loop do
    prompt(MESSAGES['second_number'])
    number2 = gets.chomp

    if valid_number?(number2)
      break
    else
      prompt(MESSAGES['number_error'])
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1). add
    2). subtract
    3). multiply
    4). divide
  MSG

  prompt(operator_prompt)

  operator = ''
  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(MESSAGES['operator_error'])
    end
  end

  # because if condition does not create a block, the variable is visible outside the if condition.
  # string interpolation can also be used for calling methods
  prompt("#{operation_to_message(operator)} the two numbers")

  result = case operator
           when '1'
             number1.to_i + number2.to_i
           when '2'
             number1.to_i - number2.to_i
           when '3'
             number1.to_i * number2.to_i
           when '4'
             number1.to_f / number2.to_f
           end

  prompt("The result is #{result}")

  prompt(MESSAGES['play_again_message'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt(MESSAGES['goodbye'])
