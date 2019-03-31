class Game < ApplicationRecord
  after_create :generate_game_details
  after_save :create_result

  validates :token, uniqueness: true

  def generate_game_details
    generate_board
    generate_token
    generate_start_and_end_time
    save
  end

  def generate_board
    possible_letters = ('A'..'Z').to_a
    wildcards = ['*', '*']
    letters_board = (0..13).map { possible_letters[rand(26)] } + wildcards
    self.board = letters_board.shuffle
  end

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def generate_start_and_end_time
    time_now = DateTime.now
    self.start_time = time_now
    self.end_time = time_now + 180.seconds
  end

  def create_result
    Result.create(game_id: id)
  end
end