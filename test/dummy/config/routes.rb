Rails.application.routes.draw do
  post 'user_tokens', to: 'user_tokens#create'
  delete 'user_tokens', to: 'user_tokens#destroy'
  post 'admin_tokens', to: 'admin_tokens#create'
  delete 'admin_tokens', to: 'admin_tokens#destroy'
  resources :user_protected
  resources :admin_protected
end
