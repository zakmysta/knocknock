Rails.application.routes.draw do
  post 'user_tokens' => 'user_tokens#create'
  post 'admin_tokens' => 'admin_tokens#create'
  resources :user_protected
  resources :admin_protected
end
