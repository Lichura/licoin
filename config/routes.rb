Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'index/index'
  post 'index/get_actual_price'
  post 'index/iniciar_bot'

  root :to => 'index#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
