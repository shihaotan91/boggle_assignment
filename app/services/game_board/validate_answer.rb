module GameBoard
  class ValidateAnswer
    include CheckAnswer

    def initialize(game, result, answer)
      @game = game
      @result = result
      @answer = answer
      @found = false
      @response = { errors: [] }
      @dictionary_details = Rails.cache.fetch(Game::DICTIONARY_DETAILS)
      @position_neighbours = I18n.t('games.board_position_neighbour')

      validate_answer
    end

    def validate_answer
      check_answer
      return @response[:errors] unless @response[:errors].empty?

      # find_answer_on_board
    end
  end
end