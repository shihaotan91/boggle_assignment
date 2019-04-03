module GameBoard
  class ValidateAnswer
    include CheckAnswer
    include FindAnswer

    def initialize(game, answer)
      @game = game
      @board = game.board
      @result = Result.find_by(game_id: game.id)
      @answer = answer.upcase
      @found = false
      @response = { errors: [] }

      return @response[:errors] if game_completed

      validate_answer
    end

    def game_completed
      completed_message = "This game has completed. The final result was #{@result.points} points"

      if @game.completed
        @response[:errors] << completed_message
        return true
      elsif @game.end_time < Time.now
        @game.completed = true
        @game.save
        @response[:errors] << completed_message
        return true
      end
      false
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
      end
    end

    def update_result
      @result.correct_answers << @answer
      @result.save
    end
  end
end