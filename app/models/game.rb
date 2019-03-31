class Game < ApplicationRecord
  after_create :generate_board
  after_create :generate_token

  validates :token, uniqueness: true

  def generate_board
    possible_letters = ('A'..'Z').to_a
    wildcards = ['*', '*']
    letters_board = (0..13).map { possible_letters[rand(26)] } + wildcards
    self.board = letters_board.shuffle
    save
  end

  def generate_token
    self.token = SecureRandom.hex(20)
    save
  end
end