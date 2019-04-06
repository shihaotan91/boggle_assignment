Rails.application.routes.draw do
  resources :games, only: %i[create]
  put 'games/play'
end
