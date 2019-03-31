namespace :game do
  desc 'Cache dictionary details'
  task cache_dictionary_details: :environment do
    dictionary = I18n.t("games.dictionary")
    grouped_dictionary = dictionary.group_by do |word|
      "#{word[0..1]}_#{word.length}"
    end
    possible_word_lengths = dictionary.map do |word|
      word.length
    end.uniq.sort

    dictionary_details = {
      grouped_dictionary: grouped_dictionary,
      min_length: possible_word_lengths.min,
      max_length: possible_word_lengths.max
    }

    cache_key = Game::DICTIONARY_DETAILS
    debugger
    Rails.cache.write(cache_key, dictionary_details)
  end
end