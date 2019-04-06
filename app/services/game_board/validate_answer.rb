module GameBoard
  class ValidateAnswer
    include CheckAnswer
    include FindAnswer

    attr_reader :response

    def initialize(game, answer)
      @game = game
      @result = Result.find_by(game_id: game.id)
      @answer = answer.upcase
      @found = false

      @response = { error_messages: [], board: @game.pretty_board }

      return @response if game_completed

      validate_answer
    end

    def game_completed
      completed_message = "This game has completed. The final result was #{@result.points} points"

      if @game.completed
        @response[:error_messages] << completed_message
        return true
      elsif @game.end_time < DateTime.now
        @game.completed = true
        @game.save
        @response[:error_messages] << completed_message
        return true
      end
      false
    end

    def validate_answer
      check_answer
      return @response unless @response[:error_messages].empty?

      find_answer

      if @found
        update_result
        @response[:success_message] = "#{@answer} is a valid word"
        @response[:current_points] = @result.points
        @response[:correct_words] = @result.correct_answers
      else
        @response[:error_messages] << "#{@answer} cannot be found on game board"
      end
    end

    def update_result
      @result.correct_answers << @answer
      @result.save
    end
  end
end