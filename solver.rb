class Solver
  attr_accessor :board, :row_values, :column_values, :square_values
  VALUES = %w[1 2 3 4 5 6 7 8 9]

  def initialize(puzzle)
    @board = build_board(puzzle)
  end

  def build_board(puzzle)
    formatted_puzzle = []
    puzzle.each_line do |line|
      line = pad_line(line.chomp)
      formatted_puzzle << line.split('')
    end
    formatted_puzzle
  end

  def pad_line(line)
    line = line.ljust(9)
  end

  def solve
    solvable = true
    while !solved? && solvable
      solvable = fill_spots
    end
    pretty_board
  end

  def solved?
    !board.flatten.include?(" ")
  end

  def fill_spots
    solved_something = false
    0.upto(80) do |index|
      row = row(index)
      column = column(index)
      if board[row][column] == " " && !answer(index).nil?
        board[row][column] = answer(index)
        solved_something = true
      end
    end
    solved_something
  end

  def row(spot_index)
  	spot_index / 9
  end

  def column(spot_index)
  	spot_index % 9
  end

  def square(spot_index)
  	((row(spot_index) / 3) * 3) + (column(spot_index) / 3)
  end

  def row_indexes(spot_index)
    indexes = (0..8).to_a.map { |i| row(spot_index) * 9 + i }
  end

  def column_indexes(spot_index)
    indexes = (0..8).to_a.map { |i| column(spot_index) + (9 * i) }
  end

  def square_indexes(spot_index)
    indexes = []
    row1 = (row(spot_index) / 3) * 3
    column1 = (column(spot_index) / 3) * 3
    (0..8).to_a.map { |i| (row1*9 + column1) + ((i/3)*3) + ((i/3)*6) + i%3 }
  end

  def row_values(row)
    board[row]
  end

  def column_values(column)
    board.map { |row| row[column] }
  end

  def square_values(square)
    values = []
    row1 = (square / 3) * 3
    column1 = (square % 3) * 3
    3.times { |i| values << row_values(row1 + i)[column1..column1 + 2]}
    values.flatten
  end

  def answer(spot_index)
    #STRANGE NESTING AVOIDS REPEATED EVALUATION OF possible_values_unsure FOR EACH TEST
    if possible_values_certain(spot_index).length == 1 then possible_values_certain(spot_index)[0]
    else
      possibles = possible_values_unsure(spot_index, row_indexes(spot_index))
      if possibles.length == 1 && !possibles[0].nil? then possibles[0]
      else
        possibles = possible_values_unsure(spot_index, column_indexes(spot_index))
        if possibles.length == 1 && !possibles[0].nil? then possibles[0]
        else
          possibles = possible_values_unsure(spot_index, square_indexes(spot_index))
          if possibles.length == 1 && !possibles[0].nil? then possibles[0]
          end
        end
      end
    end
  end

  def possible_values_certain(spot_index)
    row = row(spot_index)
    column = column(spot_index)
    square = square(spot_index)
    if board[row][column] != " "
      [board[row][column]]
    else
      VALUES - row_values(row) - column_values(column) - square_values(square)
    end
  end

  def possible_values_unsure(spot_index, spot_index_collection)
  	other_indexes = spot_index_collection - [spot_index]
    possibles = possible_values_certain(spot_index)
    other_indexes.each { |spot| possibles -= possible_values_certain(spot) }
    possibles
  end

  def pretty_board(ugly_board = board)
    pretty = ugly_board.map do |row|
      row.map { |char| char == " " ? "_" : char }.join(' ')
    end
    pretty.each { |row| row.insert(6, "| "); row.insert(14, "| ") }
    pretty.insert(3, "------+-------+------");
    pretty.insert(7, "------+-------+------")
    pretty.map { |row| row.rjust(25) }
  end
end
