Rails.application.routes.draw do

  resources :users do
    member do
      post :crop_avatar
    end
    resources :photos, :albums, :articles
  end

  resources :sessions, only: [:index, :new, :create, :destroy]

  resources :password_resets
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  get '/locale/english'
  get '/locale/russian'
  get '/format/desktop'
  get '/format/mobile'

  get '/explorer/articles'
  get '/explorer/photos'

  root 'explorer#articles'

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

end
