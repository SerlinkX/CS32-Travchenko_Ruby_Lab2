# Створюємо пріоритет операторів
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

  # Розбиваємо вхідний вираз на токени (числа та оператори)
  tokens = expression.scan(/\d+|\S/)

  tokens.each do |token|
    if token =~ /\d+/   # Якщо це число, додаємо його до вихідного списку
      output << token
    elsif token == '('  # Якщо це відкриваюча дужка, кладемо її в стек
      operators.push(token)
    elsif token == ')'  # Якщо це закриваюча дужка, виводимо всі оператори до відкриваючої
      while operators.last != '('
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
  end

  # Виводимо всі оператори, що залишилися в стеку
  while !operators.empty?
    output << operators.pop
  end

  output.join(' ')  # Повертаємо результат у вигляді рядка
end

# Приклад використання
expression = "9 * 7 / 70"
rpn_result = to_rpn(expression)
puts rpn_result
