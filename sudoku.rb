require_relative 'solver'

filename = ARGV.sample(1)[0]
puts "\nSolving #{filename}\n\n"
puzzle = File.read(filename)
solver = Solver.new(puzzle)

original_board = solver.build_board(puzzle)
puts "ORIGINAL PUZZLE:\n\n"
puts solver.pretty_board(original_board)

solution = solver.solve
puts "\nOK, you got me. This is the best I can do..." if !solver.solved?
puts "\nSOLUTION:\n\n"
puts solution

# can't solve 5, 6, 9, 24, 41, 42, 46, 47, 48, 49
