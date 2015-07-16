gem 'minitest', '~> 5.7.0'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'solver'

class SolverTest < Minitest::Test

  def test_it_can_create_a_Solver_object
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal Solver, solver.class
  end

  def test_it_builds_the_board
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)
    board = solver.build_board(puzzle)
    expected = [["8", " ", " ", "5", " ", "4", " ", " ", "7"],
                [" ", " ", "5", " ", "3", " ", "9", " ", " "],
                [" ", "9", " ", "7", " ", "1", " ", "6", " "],
                ["1", " ", "3", " ", " ", " ", "2", " ", "8"],
                [" ", "4", " ", " ", " ", " ", " ", "5", " "],
                ["2", " ", "7", "8", "1", "3", "6", " ", "4"],
                [" ", "3", " ", "9", " ", "2", " ", "8", " "],
                [" ", " ", "2", " ", "7", " ", "5", " ", " "],
                ["6", " ", " ", "3", " ", "5", " ", " ", "1"]]

    assert_equal expected, board
  end

  def test_it_builds_a_valid_board_from_a_file_without_trailing_spaces
    puzzle = File.read("first_puzzle_no_trailing_spaces.sudoku")
    solver = Solver.new(puzzle)
    board = solver.build_board(puzzle)
    expected = [["8", " ", " ", "5", " ", "4", " ", " ", "7"],
                [" ", " ", "5", " ", "3", " ", "9", " ", " "],
                [" ", "9", " ", "7", " ", "1", " ", "6", " "],
                ["1", " ", "3", " ", " ", " ", "2", " ", "8"],
                [" ", "4", " ", " ", " ", " ", " ", "5", " "],
                ["2", " ", "7", "8", "1", "3", "6", " ", "4"],
                [" ", "3", " ", "9", " ", "2", " ", "8", " "],
                [" ", " ", "2", " ", "7", " ", "5", " ", " "],
                ["6", " ", " ", "3", " ", "5", " ", " ", "1"]]

    assert_equal expected, board
  end

  def test_it_knows_what_row_a_spot_is_in
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal 2, solver.row(22)
    assert_equal 5, solver.row(51)
  end

  def test_it_knows_what_column_a_spot_is_in
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal 1, solver.column(37)
    assert_equal 8, solver.column(17)
  end

  def test_it_knows_what_square_a_spot_is_in
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal 3, solver.square(29)
    assert_equal 0, solver.square(9)
  end

  def test_it_returns_the_requested_row_indexes
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal [36, 37, 38, 39, 40, 41, 42, 43, 44], solver.row_indexes(42)
    assert_equal [0, 1, 2, 3, 4, 5, 6, 7, 8], solver.row_indexes(0)
  end

  def test_it_returns_the_requested_column_indexes
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal [3, 12, 21, 30, 39, 48, 57, 66, 75], solver.column_indexes(39)
    assert_equal [8, 17, 26, 35, 44, 53, 62, 71, 80], solver.column_indexes(80)
  end

  def test_it_returns_the_requested_square_indexes
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal [54, 55, 56, 63, 64, 65, 72, 73, 74], solver.square_indexes(65)
    assert_equal [33, 34, 35, 42, 43, 44, 51, 52, 53], solver.square_indexes(33)
  end

  def test_it_returns_the_requested_row_values
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal [" ", "3", " ", "9", " ", "2", " ", "8", " "], solver.row_values(6)
    assert_equal ["2", " ", "7", "8", "1", "3", "6", " ", "4"], solver.row_values(5)
  end

  def test_it_returns_the_requested_column_values
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal ["5", " ", "7", " ", " ", "8", "9", " ", "3"], solver.column_values(3)
    assert_equal ["7", " ", " ", "8", " ", "4", " ", " ", "1"], solver.column_values(8)
  end

  def test_it_returns_the_requested_square_values
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal [" ", " ", " ", " ", " ", " ", "8", "1", "3"], solver.square_values(4)
    assert_equal ["9", " ", "2", " ", "7", " ", "3", " ", "5"], solver.square_values(7)
  end

  def test_it_reports_the_possible_values_of_a_given_spot_that_are_certain
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal ["1", "3", "7"], solver.possible_values_certain(42)
  end

  def test_it_can_extract_the_unique_possible_value_of_one_spot_compared_to_other_unsure_spots
    puzzle = File.read("impossible_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal ["5"], solver.possible_values_unsure(26,solver.column_indexes(26))
  end

  def test_it_can_find_the_answer_for_a_single_unknown_spot
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)

    assert_equal "9", solver.answer(4)
    assert_equal "2", solver.answer(17)
    assert_equal "1", solver.answer(42)
  end

  def test_it_knows_when_a_game_is_fully_solved
    puzzle = File.read("first_puzzle.sudoku")

    solver = Solver.new(puzzle)
    solver.solve

    assert solver.solved?, "Sorry, it's not actually solved."
  end

  def test_it_can_solve_an_easy_puzzle
    puzzle = File.read("first_puzzle.sudoku")
    solver = Solver.new(puzzle)
    expected = ["    8 2 6 | 5 9 4 | 3 1 7",
                "    7 1 5 | 6 3 8 | 9 4 2",
                "    3 9 4 | 7 2 1 | 8 6 5",
                "    ------+-------+------",
                "    1 6 3 | 4 5 9 | 2 7 8",
                "    9 4 8 | 2 6 7 | 1 5 3",
                "    2 5 7 | 8 1 3 | 6 9 4",
                "    ------+-------+------",
                "    5 3 1 | 9 4 2 | 7 8 6",
                "    4 8 2 | 1 7 6 | 5 3 9",
                "    6 7 9 | 3 8 5 | 4 2 1"]

    actual = solver.solve
    assert_equal expected, actual
  end

  def test_it_knows_when_a_game_has_not_been_solved
    puzzle = File.read("unsolvable_puzzle.sudoku")
    solver = Solver.new(puzzle)
    solver.solve

    refute solver.solved?, "You didn't think it would be solved, but I think it is. Maybe you're smarter than you look."
  end

  def test_it_can_admit_defeat_without_crashing
    puzzle = File.read("unsolvable_puzzle.sudoku")
    solver = Solver.new(puzzle)
    expected = ["    _ _ _ | _ _ _ | _ _ 5",
                "    _ _ _ | _ 1 _ | _ _ 9",
                "    _ 6 _ | _ 8 _ | _ _ _",
                "    ------+-------+------",
                "    5 _ _ | _ _ _ | _ 1 _",
                "    _ _ _ | _ _ _ | _ _ _",
                "    _ 9 _ | _ _ _ | _ _ 7",
                "    ------+-------+------",
                "    _ _ 9 | _ 7 _ | _ _ 2",
                "    _ _ _ | _ _ 4 | _ _ _",
                "    4 _ _ | _ _ _ | _ _ _"]
    actual = solver.solve

    assert_equal expected, actual
  end

end
