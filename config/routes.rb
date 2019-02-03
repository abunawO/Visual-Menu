Rails.application.routes.draw do


  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  get '/user_profile' => "users#user_profile"

  #root 'static_pages#home'
  root          'static_pages#home'
  #get 'static_pages/home'
  get 'home' => 'static_pages#home'
  #get 'static_pages/help'
  get 'help' => 'static_pages#help'
  #get 'static_pages/about'
  get 'about' => 'static_pages#about'
  #get 'static_pages/pricing'
  get '/pricing' => 'static_pages#pricing'
  #get 'static_pages/contact'
  get 'contact' => 'static_pages#contact'
  #
  post "/mail_contact"  => 'static_pages#contact_us'
  #
  get "/index"  => 'static_pages#index'
  #
  get 'signup' => 'users#new'
  #
  get 'login'   => 'sessions#new'
  #
  post 'login'   => 'sessions#create'
  #
  delete 'logout'  => 'sessions#destroy'
  #
  get 'search_page'   => 'users#search'
  #
  get 'micropost_edit' => 'microposts#edit'
  #
  get 'micropost_show' => 'microposts#show'
  #
  get 'category_search' => 'users#category_search'

  patch "/microposts/:id" => 'microposts#edit'


  #Adding following and followers actions to the Users controller.
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy, :edit]
  #get 'edit'   => 'users#edit'
  #
  resources :users
  resources :relationships,       only: [:create, :destroy]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
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
