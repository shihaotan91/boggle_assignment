module GameBoard
  module FindAnswer
    def find_answer
      @board = @game.board
      @used_coordinates = []
      @answer_letter_index = 0

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
          if letter_matches(letter)
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
      valid_neighbours = neighbours - @used_coordinates

      valid_neighbours.each do |neighbour|
        mark_used_coordinate_from_board(current_coord)
        break if @found

        if letter_matches(board_letter(neighbour))
          if last_letter_of_answer
            @found = true
          else
            @answer_letter_index += 1
            find_letter_on_board(neighbours(neighbour), neighbour)
          end
        end
      end
      restore_used_coordinates
      restore_letter_index
    end

    def board_letter(coordinates)
      @board[coordinates[0]][coordinates[1]]
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

    def last_letter_of_answer
      @answer_letter_index == @answer.length - 1
    end

    def letter_matches(letter)
      [@answer[@answer_letter_index], '*'].include? letter
    end
  end
end