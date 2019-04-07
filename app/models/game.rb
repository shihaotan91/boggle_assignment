class Game < ApplicationRecord
  DICTIONARY_DETAILS = 'dictionary_details'.freeze
  before_create :generate_game_details
  after_create :create_result

  validates :token, uniqueness: true
  has_one :result, dependent: :destroy

  def generate_game_details
    generate_board
    generate_token
    generate_start_and_end_time
  end

  def generate_board
    vowels = %w(A E I O U).sample(2)
    consonance = %w(R S T L N E).sample(4)
    wildcards = %w(* *).sample(2)
    random_letters = ('A'..'Z').to_a.sample(8)

    letter_board = vowels + consonance + wildcards + random_letters

    self.board = letter_board.shuffle.each_slice(4).to_a
  end

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def generate_start_and_end_time
    time_now = DateTime.now
    self.start_time = time_now
    self.end_time = time_now + 300.seconds
  end

  def create_result
    Result.create(game_id: id)
  end

  def pretty_board
    board.map { |row| row.join(' ') }
  end

  def time_left
    time_left = end_time.to_i - DateTime.now.to_i
    if time_left.negative?
      'This game has completed'
    else
      "#{time_left} seconds"
    end
  end
end