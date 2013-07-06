Scorebot::Application.routes.draw do
  get "scoreboard", to: 'scoreboard#index', as: 'scoreboard'
  get "dashboard", to: 'dashboard#index', as: 'dashboard'

  post "redeem", to: 'redemption#create', as: 'redemption'
end
