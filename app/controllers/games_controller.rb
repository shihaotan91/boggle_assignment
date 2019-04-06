class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_missing_params, only: %i[play]

  def create
    @new_game = Game.create
    if @new_game.valid?
      new_game_json = {
        board: @new_game.pretty_board,
        token: @new_game.token,
        success_message: 'New game created! You have 5mins to play'
      }
      render json: new_game_json, status: :created
    else
      new_game_error_json = {
        error_message: @new_game.errors.messages
      }
      render json: new_game_error_json, status: :unprocessable_entity
    end
  end

  def play
    game = Game.find_by(token: game_params[:token])
    if game
      result = GameBoard::ValidateAnswer.new(game, game_params[:answer])
      result.response[:time_left] = game.time_left
      render json: result.response, status: :ok
    else
      error = 'Invalid game token'
      render json: { error_message: error }, status: :unprocessable_entity
    end
  end

  def game_params
    params.permit(:token, :answer)
  end

  def check_missing_params
    if game_params[:token].blank? || game_params[:answer].blank?
      error = 'You need to provide a game token and answer to play'
      render json: { error_message: error }, status: :unprocessable_entity
    end
  end
end
