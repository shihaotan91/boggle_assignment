class Result < ApplicationRecord
  belongs_to :game, dependent: :destroy
  before_update :calculate_points

  def calculate_points
    return if correct_answers.empty?

    self.points = correct_answers.map(&:length).sum
  end
end