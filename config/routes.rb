Rails.application.routes.draw do
  resources :productos do
    collection {post :importar}
  end
  resources :config_users
  devise_for :users
  root to: "home#index"
  devise_scope :user do
    get "/login" => "devise/sessions#new" # custom path to login/sign_in
    get "/registro" => "devise/registrations#new" # custom path to sign_up/registration
  end
  get "/me", to: "home#cuenta"
  get "socios/:id", to: "productos#tienda"
  post "generar_pedido", to:"pedidos#generar"
  get "pedidos", to: "pedidos#index"
  get "pedido/:id", to: "pedidos#show"
  get "/pedido", to: "pedidos#new"
  get  "/exportar", to: "productos#exportar"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
