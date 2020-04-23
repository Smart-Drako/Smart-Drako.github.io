class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index]

  def index
    @categorias = {
      "cat-1" => "Asadero",
      "cat-2" => "Barbería",
      "cat-3" => "Abarrotes",
      "cat-4" => "Pizzas",
      "cat-5" => "Sushi",
      "cat-6" => "Ferretería",
      "cat-7" => "Postres",
      "cat-8" => "Botanas",
    }
  end

  def cuenta
    @config_user = ConfigUser.find_or_create_by(user_id: current_user.id)
    @categorias = Category.all.order("name")
    @formas_pago = [["Efectivo", "Efectivo"] , ["Tarjetas", "Tarjetas"], ["Efectivo y Tarjetas", "Efectivo y Tarjetas"]]
    @tipos_entrega = [["A domicilio", "A domicilio"] , ["Para recoger", "Para recoger"], ["A domicilio y recoger", "A domicilio y recoger"]]
    @facturacion = [["Si", "Si"] , ["No", "No"]]
  end
end
