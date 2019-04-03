class GamesController < ApplicationController
  def show
    @game = Game.find_by(token: params[:token])
    respond_to do |format|
      format.html { render template: 'games/show' }
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
      response = GameBoard::ValidateAnswer.new(game, game_params[:answer])
      render json: response, status: :ok
    else
      error = 'Invalid game token'
      render json: error, status: :unprocessable_entity
    end
  end

  def game_params
    params.permit(:token, :answer)
  end
end
