Rails.application.routes.draw do

  resources :users, shallow: true do
    member do
      post :crop_avatar
    end
  end

  resources :photos do
    member do
      delete 'album/:album_id', :action => 'unlink_album', :as => :album
      post   'album/:album_id', :action => 'link_album'
      get    'available_albums'
    end
  end
  resources :albums, :articles

  resources :sessions, only: [:index, :new, :create, :destroy]

  resources :password_resets
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  get '/locale/english'
  get '/locale/russian'
  get '/format/desktop'
  get '/format/mobile'

  get '/explorer/index'
  get '/explorer/articles'
  get '/explorer/photos'

  root 'explorer#index'

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

end
