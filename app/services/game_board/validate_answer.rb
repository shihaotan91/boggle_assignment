module GameBoard
  class ValidateAnswer
    include CheckAnswer
    include FindAnswer

    def initialize(game, result, answer)
      @game = game
      @board = game.board
      @result = result
      @answer = answer.upcase
      @found = false
      @response = { errors: [] }

      validate_answer
    end

    def validate_answer
      check_answer
      return @response[:errors] unless @response[:errors].empty?

      find_answer

      if @found
        update_result
        @response[:success] = "#{@answer} is a valid word"
      else
        @response[:errors] << "#{@answer} cannot be found on game board"
        @response[:errors]
      end
    end

    def update_result
      @result.correct_answers << @answer
      @result.save
    end
  end
end