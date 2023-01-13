Rails.application.routes.draw do
  devise_for :suppliers
  devise_for :offtakers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
