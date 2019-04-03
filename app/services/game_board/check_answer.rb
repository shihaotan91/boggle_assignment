module GameBoard
  module CheckAnswer
    def check_answer(dictionary_details)
      check_for_invalid_characters
      check_answer_length(dictionary_details[:min_length], dictionary_details[:max_length])
      check_if_answer_is_in_dictionary(dictionary_details[:grouped_dictionary])
      check_duplicated_answers
    end

    def check_for_invalid_characters
      alphabet_regex = /^[a-zA-Z]+$/
      unless @answer.match(alphabet_regex)
        @response[:errors] << 'Your answer must contain only letters'
      end
    end

    def check_if_answer_is_in_dictionary(grouped_dictionary)
      unless grouped_dictionary["#{@answer[0..1]}_#{@answer.length}"].include? @answer.downcase
        @response[:errors] << 'Word cannot be found in dictionary'
      end
    end

    def check_answer_length(min_length, max_length)
      unless @answer.length.between?(min_length, max_length)
        @response[:errors] << "Word length must be between #{min_length} and #{max_length}"
      end
    end

    def check_duplicated_answers
      all_answers = @result.correct_answers
      if all_answers.include? @answer
        @response[:errors] << "You've answered correctly with this word(#{@answer}) before"
      end
    end
  end
end