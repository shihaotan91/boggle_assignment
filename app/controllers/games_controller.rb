class GamesController < ApplicationController
  def create
    new_game = Game.create
    if new_game
      render json: new_game.board, status: :created
    else
      render json: new_game.errors, status: :unprocessable_entity
    end
  end

  def play
  end
end
