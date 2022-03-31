Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  # get '/articles', to: 'articles#index'
  resources :articles, only: %i[index show]
end
