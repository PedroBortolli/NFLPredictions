Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get 'predictions' => 'pages#predictions'
  #get 'about' => 'pages#about'
  #get 'result' => 'pages#result'
  post 'update' => 'pages#update'
  get 'view' => 'pages#view'
  get 'compare' => 'pages#compare'
  get 'standings' => 'pages#standings'
  get 'ranking' => 'pages#ranking'
end
