Rails.application.routes.draw do
  get 'replacements/index'

  get 'replacements/show'

  get 'replacements/new'

  resources :tickets do
    member do
      post :resolve
      post :unresolve
    end
  end

  resources :rounds

  resources :replacements

  get "scoreboard", to: 'scoreboard#index', as: 'scoreboard'
  get "dashboard", to: 'dashboard#index', as: 'dashboard'
  get "howto", to: "high_voltage/pages#show", id: 'howto', as: 'howto'

  post "redeem", to: 'redemption#create', as: 'redemption'

  get 'timers', to: 'timers#index', as: 'timers'

  get 'livectf/:flag', to: 'livectf#capture', as: 'livectf'

  root to: redirect('/dashboard')

  namespace :admin do
    root to: 'root#index'
    resources :rounds,
              :tokens,
              :redemptions,
              :instances,
              :teams,
              :availabilities,
              :replacements

    resources :services do
      resources :availabilities, controller: 'services/availabilities'
    end
  end

end
