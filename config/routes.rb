Rails.application.routes.draw do
  devise_for :suppliers, controllers: { 
    registrations: "suppliers/registrations",
    sessions: "suppliers/sessions"
   }
  devise_for :offtakers, controllers: { 
    registrations: "offtakers/registrations",
    sessions: "offtakers/sessions"
   }
   devise_for :admins, controllers: { 
    registrations: "admin/registrations",
    sessions: "admin/sessions"
   }, path: 'admin'

  authenticate :admin, ->(admin) { admin } do
    namespace :admin do
      get '/', to: 'supplier_locations#index'
      post '/supplier_locations/:id/verify', as: :verify, to: "supplier_locations#verify"
    end
  end



  resources :scenarios, only: [:create, :show, :destroy]
  post '/scenarios/:id/mark-favourite', as: :mark_favourite, to: "scenarios#mark_favourite"
  post '/scenarios/:id/calculate-again', as: :calculate_again, to: "scenarios#calculate_again"


  namespace :suppliers, suppliers: true do 
    get '/', to: 'supplier_locations#dashboard'
    resources :supplier_locations, except: [:index]
  end

  namespace :offtakers, offtakers: true do 
    get '/', to: 'offtaker_locations#dashboard'
    resources :offtaker_locations, except: [:index]
  end

  root 'pages#home'
  get '/about', to: "pages#about"
  get '/terms_and_conditions', to: "pages#terms_and_conditions"
  get '/privacy_statement', to: "pages#privacy_statement"

end
