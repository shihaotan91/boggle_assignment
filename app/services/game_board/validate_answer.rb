module GameBoard
  class ValidateAnswer
    include CheckAnswer
    include FindAnswer

    def initialize(game, result, answer)
      @game = game
      @board = game.board
      @result = result
      @answer = answer
      @response = { errors: [] }
      dictionary_details = Rails.cache.fetch(Game::DICTIONARY_DETAILS)

      validate_answer(dictionary_details)
    end

    def validate_answer(dictionary_details)
      check_answer(dictionary_details)
      return @response[:errors] unless @response[:errors].empty?

      found = find_answer
      debugger
    end
  end
end