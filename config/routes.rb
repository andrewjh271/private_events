Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'events#index'
  
  devise_for :users
  resource :user, only: :show
  
  get 'about', to: 'application#about'
  
  resources :events do
    # resources :invitations, only: :new
    resource :invitations, only: [:new, :edit, :create, :update]
  end

  resources :invitations, only: [:destroy] do
    member do
      post 'accept'
      post 'pend'
      post 'decline'
    end
  end
end
