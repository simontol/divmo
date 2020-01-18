Divertissimo::Application.routes.draw do

  get "home/index"

  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  resources :users, :only => [:show, :index]
  post '/set_geolocation' => 'users#set_geolocation'


  authenticated :user do
    root :to => "home#dashboard", :as => "home_dashboard"
  end
  
  resources :events do
    member do
      post 'attend'
      post 'unattend'
    end
  end

  resources :groups do
    member do
      post 'follow'
      post 'unfollow'
      #post 'change_role'
      #get 'members'
    end
    resources :members
    resources :events
  end

  resources :users do
    member do
      post 'follow'
      post 'unfollow'
    end
  end

  match "venues" => "groups#venues", :via => [:get], :as => 'groups_venues'
  match "artists" => "groups#artists", :via => [:get], :as => 'groups_artists'

  resources :members

  root :to => 'events#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
