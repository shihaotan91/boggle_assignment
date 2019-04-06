module GameBoard
  module CheckAnswer
    def check_answer
      check_for_invalid_characters
      check_answer_length
    end

    def check_for_invalid_characters
      alphabet_regex = /^[a-zA-Z]+$/
      unless @answer.match(alphabet_regex)
        return @response[:error_messages] << 'Your answer must contain only letters'
      end
    end

    def check_answer_length
      dictionary_details = Rails.cache.fetch(Game::DICTIONARY_DETAILS)
      min_length = dictionary_details[:min_length]
      max_length = dictionary_details[:max_length]

      unless @answer.length.between?(min_length, max_length)
        return @response[:error_messages] << "Word length must be between #{min_length} and #{max_length} characters"
      end

      check_if_answer_is_in_dictionary(dictionary_details[:grouped_dictionary])
    end

    def check_if_answer_is_in_dictionary(grouped_dictionary)
      answer_group = grouped_dictionary["#{@answer[0..1]}_#{@answer.length}"]
      return unless answer_group

      unless answer_group.include? @answer.downcase
        return @response[:error_messages] << 'Word cannot be found in dictionary'
      end

      check_duplicated_answers
    end

    def check_duplicated_answers
      if @result.correct_answers.include? @answer
        @response[:error_messages] << "You've answered correctly with this word(#{@answer}) before"
      end
    end
  end
end