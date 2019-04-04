class Result < ApplicationRecord
  belongs_to :game, dependent: :destroy
end