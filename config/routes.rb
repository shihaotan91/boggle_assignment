Rails.application.routes.draw do
  resources :games, only: %i[create show], param: :token
  post 'games/play'
end
