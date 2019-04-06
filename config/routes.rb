Rails.application.routes.draw do
  resources :games, only: %i[create show], param: :token
  put 'games/play'
end
