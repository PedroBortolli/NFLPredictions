Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#test'
  get 'about' => 'pages#about'
  get 'result' => 'pages#result'
  post 'update' => 'pages#update'
end
