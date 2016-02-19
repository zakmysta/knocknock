Rails.application.routes.draw do
  resources :user_tokens, only: [:create, :destroy]
  resources :admin_tokens, only: [:create, :destroy]
  resources :user_protected
  resources :admin_protected
end
