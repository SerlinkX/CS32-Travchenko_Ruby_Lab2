# Пріоритет операторів
PRIORITY = {
  '+' => 1,
  '-' => 1,
  '*' => 2,
  '/' => 2,
  '(' => 0,
  ')' => 0
}

def to_rpn(expression)
  output = []   # Черга для зберігання результату
  operators = [] # Стек операторів
  prev_token = nil # Зберігає попередній токен для визначення унарного мінуса

  # Розбиваємо вхідний вираз на токени (числа та оператори, включно з десятковими)
  tokens = expression.scan(/\d+\.\d+|\d+|\S/)

  tokens.each_with_index do |token, i|
    if token =~ /\d+(\.\d+)?/   # Якщо це число (включаючи дробові)
      output << token
    elsif token == '-' && (prev_token.nil? || ['(', '+', '-', '*', '/'].include?(prev_token))
      # Унарний мінус, додаємо наступне число з мінусом
      next_token = tokens[i+1]
      raise "Помилка: невірний вираз після унарного мінуса" if next_token.nil? || next_token !~ /\d+(\.\d+)?/
      output << "-#{next_token}"
      prev_token = next_token # Пропускаємо число після унарного мінуса
      next
    elsif token == '('
      operators.push(token)
    elsif token == ')'
      while operators.last != '('
        raise "Помилка: зайві дужки або відсутня відкриваюча дужка" if operators.empty?
        output << operators.pop
      end
      operators.pop # Видаляємо відкриваючу дужку зі стеку
    else
      # Якщо це оператор, виводимо всі оператори з більшим або рівним пріоритетом
      while !operators.empty? && PRIORITY[operators.last] >= PRIORITY[token]
        output << operators.pop
      end
      operators.push(token)
    end

    prev_token = token
  end

  # Виводимо всі оператори, що залишилися в стеку
  while !operators.empty?
    raise "Помилка: непарні дужки або зайві оператори" if operators.last == '(' || operators.last == ')'
    output << operators.pop
  end

  output.join(' ')  # Повертаємо результат у вигляді рядка
end

def evaluate_rpn(rpn_expression)
  stack = []
  rpn_expression.split.each do |token|
    if token =~ /-?\d+(\.\d+)?/  # Число (включаючи унарні від'ємні числа)
      stack.push(token.to_f)
    else
      b = stack.pop
      a = stack.pop
      case token
      when '+'
        stack.push(a + b)
      when '-'
        stack.push(a - b)
      when '*'
        stack.push(a * b)
      when '/'
        raise "Помилка: ділення на нуль" if b == 0
        stack.push(a / b)
      else
        raise "Невідомий оператор: #{token}"
      end
    end
  end

  stack.pop  # Результат обчислення
end

# Приклади
expressions = [
  "- 2 + 4",          # Унарний мінус
  "3 - 5 +",          # Недійсний вираз (відсутній операнд)
  "1 / 0",            # Ділення на нуль
  "3.4 + 5.9",        # Дробові числа
  "4 - 5 + ( - 4 + 5 )" # Складний вираз з дужками і унарним мінусом
]

expressions.each do |expression|
  begin
    rpn = to_rpn(expression)
    puts "RPN для '#{expression}' -> #{rpn}"
    result = evaluate_rpn(rpn)
    puts "Результат обчислення: #{result}"
  rescue => e
    puts "Помилка для виразу '#{expression}': #{e.message}"
  end
  puts
end
