Scorebot::Application.routes.draw do
  get "scoreboard", to: 'scoreboard#index', as: 'scoreboard'
  get "dashboard", to: 'dashboard#index', as: 'dashboard'
  get "howto", to: "high_voltage/pages#show", id: 'howto', as: 'howto'

  post "redeem", to: 'redemption#create', as: 'redemption'

  root to: redirect('/dashboard')
end
