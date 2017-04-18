Rails.application.routes.draw do
  resources :shares
  match "shares/:id/sell_share" => "shares#sell_share", :via => :get, :as => 'sell_share'
  match "shares/:id/complete_share_sale" => "shares#complete_share_sale", :via => :patch, :as => 'complete_share_sale'

  resources :account_transactions

  resources :houses

  resources :tasks do
    member do
      post :complete_task
      post :complete_task_widget
    end
  end

  get 'admin/index'

  get 'import_transactions/open_file'

  post 'import_transactions/process_file'

  match "import_transactions/:id" => "import_transactions#destroy", :via => :delete, :as => 'destroy_imported_transaction'

  match "import_transactions/:id/transfer" => "import_transactions#transfer", :via => :get, :as => 'transfer_imported_transaction'

  match "import_transactions/:id/update" => "import_transactions#update", :via => :patch, :as => 'imported_transaction'

  get 'import_transactions/import'

  get 'import_transactions/cancel'

  match "import_transactions/:id/split" => "import_transactions#split", :via => :get, :as => 'split_imported_transaction'
  match "import_transactions/add_split" => "import_transactions#add_split", :via => :post, :as => 'add_split_imported_transaction'

  match "import_transactions/:id/tags" => "import_transactions#tags", :via => :get, :as => 'tags_imported_transaction'
  match "import_transactions/add_tags" => "import_transactions#add_tags", :via => :post, :as => 'add_tags_imported_transaction'


  resources :budget_transactions
  match "budget_transactions/:id/edit_budget_item_transaction" => "budget_transactions#edit_budget_item_transaction", :via => :get, :as => 'edit_budget_item_transaction'
  match "budget_transactions/:id/update_cleared_status" => "budget_transactions#update_cleared_status", :via => :get, :as => 'update_cleared_status'
  # match "budget_transactions/:id/import_transactions" => "budget_transactions#import_transactions", :via => :get, :as => 'edit_budget_item_transaction'
  get 'tags/:tag/:budget_id', to: 'budget_transactions#index', as: :tag
  match "search" => "budget_transactions#index", :via => :post, as: :search

  resources :payees
  post 'payees/select_payee'

  resources :budget_incomes
  match "budget_incomes/:id/show_income_splits" => "budget_incomes#show_income_splits", :via => :get, :as => 'show_income_splits'
  match "budget_incomes/:id/generate_income_splits" => "budget_incomes#generate_income_splits", :via => :post, :as => 'generate_income_splits'

  resources :incomes

  resources :accounts

  resources :account_types

  resources :budgets do
    member do
      post :update_progress
    end
  end
  match "budgets/show_or_create/:month" => "budgets#show_or_create", :via => :get, :as => 'show_or_create_budget'


  resources :budget_items, :only => [:edit,:show,:update]
  match "budget_items/:id/one_click_transaction" => "budget_items#one_click_transaction", :via => :post, :as => 'one_click_transaction'

  resources :dashboard, :only => [:index]

  resources :categories
  match "categories/:id/edit_transaction_category" => "categories#edit_transaction_category", :via => :get, :as => 'edit_transaction_category'
  post 'categories/select_transaction_category'

  resources :master_categories

  get 'loans/index'

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
