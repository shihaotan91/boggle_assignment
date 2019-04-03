module GameBoard
  module FindAnswer
    def find_answer
      @used_coordinates = []

      starting_coordinates.each do |coord|
        break if @found
        restore_letter_index
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
      mark_used_coordinate_from_board(current_coord)

      neighbours.each do |neighbour|
        break if @found
        next if @used_coordinates.include? neighbour

        neighbour_letter = @board[neighbour[0]][neighbour[1]]

        if [@answer[@answer_letter_index], '*'].include? neighbour_letter
          if @answer_letter_index == @answer.length - 1
            @found = true
          else
            @answer_letter_index += 1
            find_letter_on_board(neighbours(neighbour), neighbour)
          end
        end
        restore_used_coordinates
      end
    end

    def mark_used_coordinate_from_board(coordinate)
      @used_coordinates << coordinate
    end

    def restore_letter_index
      @answer_letter_index = 1
    end

    def restore_used_coordinates
      @used_coordinates = []
    end
  end
end