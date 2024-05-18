Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'events#index'
  
  devise_for :users
  resource :user, only: :show, as: :profile
  resources :users, only: :show
  
  get 'about', to: 'application#about'
  
  resources :events do
    resource :invitations, only: [:new, :edit, :update, :create]
  end

  resources :invitations, only: [] do
    member do
      post 'accept'
      post 'pend'
      post 'decline'
    end
  end
end
