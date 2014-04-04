Spree::Core::Engine.routes.draw do
  get 'suggestions', to: 'suggestions#index'
  namespace :admin do
  	resources :suggestions
  end
end
