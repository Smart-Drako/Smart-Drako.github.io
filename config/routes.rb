Rails.application.routes.draw do
  resources :productos do
    collection {post :importar}
  end
  resources :config_users
  root to: "home#landing"
  devise_scope :user do
    get "/login" => "devise/sessions#new" # custom path to login/sign_in
    get "/registro" => "devise/registrations#new" # custom path to sign_up/registration
  end

  devise_for :users, :controllers => {:registrations => "registrations"}
  get "/me", to: "home#cuenta"
  get "/plan", to: "home#plan"
  get "socios/:id", to: "productos#tienda"
  get "preview", to: "productos#tienda_preview"
  get "/admin_efra", to: "home#admin_efra"
  # Programas y recomendados
  get "/programas", to: "programas#index"
  get "/recomendados", to: "recomendados#index"
  
  post "/generar_pedido", to:"pedidos#generar"
  post "/pedido/calcular_envio", to:"pedidos#calcular_envio"
  post "/pedido/solicitar_reparto", to:"pedidos#solicitar_reparto"
  get "/pedidos", to: "pedidos#index"
  get "/pedidos_recomendados", to: "pedidos#recomendados"
  get "/pedido/:id", to: "pedidos#show"
  post "/pedido/actualizar_estatus", to: "pedidos#actualizar_estatus"
  get "/pedido", to: "pedidos#new"
  get  "/exportar", to: "productos#exportar"
  get "/ver_pedido/:id", to: "pedidos#ver_pedido"
  get "descargar_pdf/:id/", to: "pedidos#descargar_pdf", as: "descargar_pdf"
  get "descargar_qr/:id/", to: "home#descargar_qr", as: "descargar_qr" 
  post "/borrar_imagen", to: "productos#borrar_imagen", as: "borrar_imagen"
  get "/recrear_fotos", to: "productos#recrear_fotos", as: "recrear_fotos"
  get "/reportes", to: "reportes#index", as: "reportes"
  get  "/reportes/pedidos", to: "reportes#reporte_pedidos"
  get  "/reportes/productos", to: "reportes#reporte_productos"

  #Cambios con la landing
  get "comunidad", to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
