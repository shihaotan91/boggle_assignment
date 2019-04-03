class GamesController < ApplicationController
  def create
    new_game = Game.create
    if new_game
      new_game_json = {
        board: new_game.board,
        token: new_game.token
      }
      render json: new_game_json, status: :created
    else
      render json: new_game.errors, status: :unprocessable_entity
    end
  end

  def play
    game = Game.find_by(token: game_params[:token])
    if game
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
