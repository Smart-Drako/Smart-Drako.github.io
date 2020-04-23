class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index]

  def index
    @negocios = Array.new
    cats = ConfigUser.distinct.pluck(:category_id)
    @categorias = Category.where(id: cats)
    
    @categorias.each do |cat|
      lista = Hash.new
      negocios = ConfigUser.where(category_id: cat.id)
      item = {
        id: cat.id,
        nombre: cat.name,
        negocios: negocios
      }
      @negocios.push(item)
    end
  end

  def cuenta
    @config_user = ConfigUser.find_or_create_by(user_id: current_user.id)
    @categorias = Category.all.order("name")
    @formas_pago = [["Efectivo", "1"] , ["Tarjetas", "2"], ["Efectivo y Tarjetas", "3"]]
    @tipos_entrega = [["A domicilio", "1"] , ["Para recoger", "2"], ["A domicilio y recoger", "3"]]
    @facturacion = [["Si", "Si"] , ["No", "No"]]
  end
end
