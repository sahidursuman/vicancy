require 'sidekiq/web'

Vicancy::Application.routes.draw do

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
      namespace :client, module: 'client' do
        post :auth
        resources :videos, only: [:index] do
          member do
            post 'edit'
            post 'delete'
          end
        end
        namespace :videos do
          get 'embed_code'
          post 'add', action: :add
          post 'request', action: :add # for old widget support
        end
      end

      namespace :reseller, module: 'reseller' do
        post :new_video_request, :defaults => { :format => :html }
        namespace :videos do
          post 'list'
        end
      end

    end
  end

  get 'embed/test' => 'embed#test'

  get 'widget' => 'widget#show'
  get 'widget/test_request_vicancy' => 'widget#test_request_vicancy'
  get 'widget/embed' => 'widget#embed'
  get 'widget/test' => 'widget#test'

  resources :video_requests, only: [:create]
  resources :attachments, only: [:show] do
    member do
      get 'download'
    end
  end

  Vicancy::STATIC_PAGE_SLUGS = %w(
    bali
    bedrijfsanimaties
    formulier
    gebruikersvoorwaarden
    jobs
    jobsform
    nl
    pricing
    privacypolicy
    product
    support
    team
    videoconsultancy
    ) unless defined?(Vicancy::STATIC_PAGE_SLUGS)

  resources :resellers, only: [] do
    member do
      get '/', action: 'clients'
      get 'clients'
      get 'install'
    end
  end
  resources :simple_orders, only: [:create]

  resources :clients, only: [:show]
  resources :users, only: [:show]
  resources :videos, only: [:destroy] do
    resources :video_edits, only: [:new, :create]
  end
  match 'oauth2callback' => 'oauth2callback#index'
  match 'contact' => 'contact#submit_message', via: :post

  resources :vimeo_imports, only: [:new, :create]

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'static_pages#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  Vicancy::STATIC_PAGE_SLUGS.each do |slug|
    match slug => "static_pages##{slug}"
  end
  match 'en' => "static_pages#en"
  match 'en-edited' => "static_pages#en_edited"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
