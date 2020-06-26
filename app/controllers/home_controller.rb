class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index]

  def index
    @negocios = Array.new
    cats = ConfigUser.where(activo: 1).distinct.pluck(:category_id)
    @categorias = Category.where(id: cats)
    
    @categorias.each do |cat|
      negocios = ConfigUser.where(category_id: cat.id, activo: 1)
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
    @bancos = [["Banco Azteca", "Banco Azteca"] , ["Banorte", "Banorte"], ["Bancoppel", "Bancoppel"], ["Banregio", "Banregio"], ["BBVA Bancomer", "BBVA Bancomer"], ["Citibanamex", "Citibanamex"], ["HSBC", "HSBC"], ["Santander", "Santander"], ["Scotiabank", "Scotiabank"]]
  end
end
