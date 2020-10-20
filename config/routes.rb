Rails.application.routes.draw do
  resources :events
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'events#index'

  devise_for :users
  resource :user, only: :show

  get 'about', to: 'application#about'

  resources :invitations, only: [:create, :new, :destroy] do
    member do
      post 'accept'
      post 'pend'
      post 'decline'
    end
  end
end
