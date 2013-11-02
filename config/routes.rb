Spree::Core::Engine.routes.append do
  get 'suggestions', to: 'suggestions#index'
  namespace :admin do
  	resources :suggestions
  end
end
