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
    game = Game.find_by(token: game_params[:token])
    if game
      result = Result.find_by(game_id: game.id)
      response = Game::CheckAnswer(game, result, game_params[:answer])
      render json: response, status: :ok
    else
      error = "Invalid game token"
      render json: error, status: :unprocessable_entity
    end
  end

  def game_params
    params.permit(:token, :answer)
  end
end
