module GameBoard
  module FindAnswer
    def find_answer
      starting_coordinates.each do |coord|
        restore_board
        find_letter_on_board(neighbours(coord), coord)
      end
    end

    def starting_coordinates
      starting_coordinates = []

      @board.each_with_index do |row, row_index|
        row.each_with_index do |letter, letter_index|
          if [@answer[0], '*'].include? letter
            starting_coordinates << [row_index, letter_index]
          end
        end
      end

      starting_coordinates
    end

    def neighbours(coordinate)
      x = coordinate[0]
      y = coordinate[1]

      potential_neighbours = [x - 1, x, x + 1].product([y - 1, y, y + 1])
      potential_neighbours.delete([x, y])
      potential_neighbours.select do |neighbour|
        (neighbour & [-1, 4]).none?
      end
    end

    def find_letter_on_board(neighbours, current_coord)
      remove_coordinate_from_board(current_coord)

      neighbours.each do |neighbour|
        neighbour_letter = @board[neighbour[0]][neighbour[1]]
        next if neighbour_letter == nil
        if [@answer[@answer_letter_index], '*'].include? neighbour_letter
          if @answer_letter_index == @answer.length - 1
            break true
          else
            @answer_letter_index += 1
            find_letter_on_board(neighbours(neighbour), neighbour)
          end
        end
      end
      false
    end

    def remove_coordinate_from_board(coordinate)
      @board[coordinate[0]][coordinate[1]] = nil
    end

    def restore_board
      @answer_letter_index = 1
      @board = @game.board
    end
  end
end