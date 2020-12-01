Rails.application.routes.draw do
  resources :productos do
    collection {post :importar}
  end
  resources :config_users
  root to: "home#index"
  devise_scope :user do
    get "/login" => "devise/sessions#new" # custom path to login/sign_in
    get "/registro" => "devise/registrations#new" # custom path to sign_up/registration
  end

  devise_for :users, :controllers => {:registrations => "registrations"}
  get "/me", to: "home#cuenta"
  get "/plan", to: "home#plan"
  get "socios/:id", to: "productos#tienda"
  get "/admin_efra", to: "home#admin_efra"
  
  post "/generar_pedido", to:"pedidos#generar"
  post "/pedido/calcular_envio", to:"pedidos#calcular_envio"
  post "/pedido/solicitar_reparto", to:"pedidos#solicitar_reparto"
  get "/pedidos", to: "pedidos#index"
  get "/pedido/:id", to: "pedidos#show"
  post "/pedido/actualizar_estatus", to: "pedidos#actualizar_estatus"
  get "/pedido", to: "pedidos#new"
  get  "/exportar", to: "productos#exportar"
  get "/ver_pedido/:id", to: "pedidos#ver_pedido"
  get "descargar_pdf/:id/", to: "pedidos#descargar_pdf", as: "descargar_pdf"
  post "/borrar_imagen", to: "productos#borrar_imagen", as: "borrar_imagen"
  get "/recrear_fotos", to: "productos#recrear_fotos", as: "recrear_fotos"
  get "/reportes", to: "reportes#index", as: "reportes"
  get  "/reportes/pedidos", to: "reportes#reporte_pedidos"
  get  "/reportes/productos", to: "reportes#reporte_productos"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
