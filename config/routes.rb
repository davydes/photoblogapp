Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :users, shallow: true do
    member do
      post :crop_avatar
    end
  end

  resources :photos, concerns: :paginatable do
    member do
      get    'in/:context',     action: 'show', as: :in
      delete 'album/:album_id', action: 'unlink_album', as: :album
      post   'album/:album_id', action: 'link_album'
      get    'available_albums'
    end
  end
  resources :albums
  resources :articles
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

  # deprecated link
  get '/explorer/articles/:id', to: redirect('/articles/%{id}')
  
end
