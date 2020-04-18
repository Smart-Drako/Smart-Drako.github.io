Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  devise_scope :user do
    get "/login" => "devise/sessions#new" # custom path to login/sign_in
    get "/registro" => "devise/registrations#new" # custom path to sign_up/registration
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
