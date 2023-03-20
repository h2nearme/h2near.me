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

  namespace :api do
    namespace :v1 do
      # Offtaker location creation
      get '/charts/offtaker_location_weekly', 
      to: 'charts#offtaker_location_weekly', 
      as: 'charts_offtaker_location_weekly'

      get '/charts/offtaker_location_monthly', 
      to: 'charts#offtaker_location_monthly', 
      as: 'charts_offtaker_location_monthly'

      get '/charts/offtaker_location_yearly', 
      to: 'charts#offtaker_location_yearly', 
      as: 'charts_offtaker_location_yearly'  

      # Offtaker location by volume requested
      get '/charts/offtaker_location_volume_weekly', 
      to: 'charts#offtaker_location_volume_weekly', 
      as: 'charts_offtaker_location_volume_weekly'

      get '/charts/offtaker_location_volume_monthly', 
      to: 'charts#offtaker_location_volume_monthly', 
      as: 'charts_offtaker_location_volume_monthly'

      get '/charts/offtaker_location_volume_yearly', 
      to: 'charts#offtaker_location_volume_yearly', 
      as: 'charts_offtaker_location_volume_yearly'  

      # Offtaker location by oxygen_interest requested
      get '/charts/offtaker_location_oxygen_interest_weekly', 
      to: 'charts#offtaker_location_oxygen_interest_weekly', 
      as: 'charts_offtaker_location_oxygen_interest_weekly'

      get '/charts/offtaker_location_oxygen_interest_monthly', 
      to: 'charts#offtaker_location_oxygen_interest_monthly', 
      as: 'charts_offtaker_location_oxygen_interest_monthly'

      get '/charts/offtaker_location_oxygen_interest_yearly', 
      to: 'charts#offtaker_location_oxygen_interest_yearly', 
      as: 'charts_offtaker_location_oxygen_interest_yearly'  

      # Scenario creation
      get '/charts/scenario_weekly', 
      to: 'charts#scenario_weekly', 
      as: 'charts_scenario_weekly'

      get '/charts/scenario_monthly', 
      to: 'charts#scenario_monthly', 
      as: 'charts_scenario_monthly'

      get '/charts/scenario_yearly', 
      to: 'charts#scenario_yearly', 
      as: 'charts_scenario_yearly'  

      # Average road costs
      get '/charts/average_road_costs_weekly', 
      to: 'charts#average_road_costs_weekly', 
      as: 'charts_average_road_costs_weekly'

      get '/charts/average_road_costs_monthly', 
      to: 'charts#average_road_costs_monthly', 
      as: 'charts_average_road_costs_monthly'

      get '/charts/average_road_costs_yearly', 
      to: 'charts#average_road_costs_yearly', 
      as: 'charts_average_road_costs_yearly'  

      # Average distance
      get '/charts/average_distance_weekly', 
      to: 'charts#average_distance_weekly', 
      as: 'charts_average_distance_weekly'

      get '/charts/average_distance_monthly', 
      to: 'charts#average_distance_monthly', 
      as: 'charts_average_distance_monthly'

      get '/charts/average_distance_yearly', 
      to: 'charts#average_distance_yearly', 
      as: 'charts_average_distance_yearly'  

      # Average pipeline costs
      get '/charts/average_pipeline_costs_weekly', 
      to: 'charts#average_pipeline_costs_weekly', 
      as: 'charts_average_pipeline_costs_weekly'

      get '/charts/average_pipeline_costs_monthly', 
      to: 'charts#average_pipeline_costs_monthly', 
      as: 'charts_average_pipeline_costs_monthly'

      get '/charts/average_pipeline_costs_yearly', 
      to: 'charts#average_pipeline_costs_yearly', 
      as: 'charts_average_pipeline_costs_yearly'  

      # Offtaker creation
      get '/charts/offtaker_weekly', 
      to: 'charts#offtaker_weekly', 
      as: 'charts_offtaker_weekly'

      get '/charts/offtaker_monthly', 
      to: 'charts#offtaker_monthly', 
      as: 'charts_offtaker_monthly'

      get '/charts/offtaker_yearly', 
      to: 'charts#offtaker_yearly', 
      as: 'charts_offtaker_yearly'  

      # Offtaker scenarios created
      get '/charts/offtaker_scenarios_created_weekly', 
      to: 'charts#offtaker_scenarios_created_weekly', 
      as: 'charts_offtaker_scenarios_created_weekly'

      get '/charts/offtaker_scenarios_created_monthly', 
      to: 'charts#offtaker_scenarios_created_monthly', 
      as: 'charts_offtaker_scenarios_created_monthly'

      get '/charts/offtaker_scenarios_created_yearly', 
      to: 'charts#offtaker_scenarios_created_yearly', 
      as: 'charts_offtaker_scenarios_created_yearly'  
    end
  end

  resources :scenarios, only: [:create, :show, :destroy]
  post '/scenarios/:id/mark-favourite', as: :mark_favourite, to: "scenarios#mark_favourite"
  post '/scenarios/:id/calculate-again', as: :calculate_again, to: "scenarios#calculate_again"


  namespace :suppliers, suppliers: true do 
    get '/', to: 'supplier_locations#dashboard'
    get '/filter', to: 'supplier_locations#filter', as: :filter
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
