Rails.application.routes.draw do

  resources :proposals do
    member do
      get 'accept'
    end
    collection do
      get 'outbox'
    end
  end

  get 'welcome/index'

  resources :groups do
    member do
      get     'edit_users'
      patch   'add_users'
      patch   'delete_users'
    end
    collection do
      post    'set_workspace'
    end
  end

  resources :conversations do
    member do
      post 'create_message'
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  match '/sign_in', to: 'sessions#new', via: :get
  match '/sign_out', to: 'sessions#destroy', via: :delete

  resources :users
  match '/sign_up',  to: 'users#new', via: :get

  
  resources :tasks do
    collection do
      post 'edit_sort'
      get 'all_tasks'
      get 'clear_sort'
      get 'in_control'
    end
    member do
      get 'complete'
      post 'delegate'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named ro-ute that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
