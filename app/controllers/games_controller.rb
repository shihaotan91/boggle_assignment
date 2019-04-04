class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @game = Game.find_by(token: params[:token])
    respond_to do |format|
      format.html { render template: 'games/show', status: :ok }
      format.json { render json: @game.to_json, status: :ok }
    end
  end

  def create
    @new_game = Game.create
    if @new_game
      new_game_json = {
        board: @new_game.board,
        token: @new_game.token
      }
      render json: new_game_json, status: :created
    else
      render json: new_game.errors, status: :unprocessable_entity
    end
  end

  def play
    game = Game.find_by(token: game_params[:token])
    if game
      result = GameBoard::ValidateAnswer.new(game, game_params[:answer])
      if result.response[:errors].empty?
        render json: result.response[:success], status: :ok
      else
        render json: result.response[:errors], status: :ok
      end
    else
      error = 'Invalid game token'
      render json: error, status: :unprocessable_entity
    end
  end

  def game_params
    params.permit(:token, :answer)
  end
end
