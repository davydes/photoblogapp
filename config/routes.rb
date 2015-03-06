Rails.application.routes.draw do

  get 'sitemap.xml' => 'sitemap#index', as: 'sitemap', defaults: { format: 'xml' }

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy], :on => :member
  end

  concern :voteable do
    resources :votes, only: [:create, :destroy], :on => :member
  end

  resources :users, shallow: true do
    member do
      post :crop_avatar
    end
    resources :photos, only: :index
  end

  resources :photos, concerns: [:paginatable, :voteable] do
    member do
      get    'in/:context',     action: 'show', as: :in
      delete 'album/:album_id', action: 'unlink_album', as: :album
      post   'album/:album_id', action: 'link_album'
      get    'available_albums'
    end
  end
  resources :albums
  resources :articles, concerns: :commentable do
    member do
      post :publish
      post :publish_to_sandbox
      post :unpublish
    end
  end
  resources :sessions, only: [:index, :new, :create, :destroy]
  resources :activities, only: :index

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
  get '/explorer/articles_in_sandbox'
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
