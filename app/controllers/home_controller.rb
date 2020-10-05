class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :error]

  def index
    @negocios = Array.new
    @ciudades_negocios = ConfigUser.where(activo: 1).distinct.pluck(:ciudad)
    @ciudad = params[:city] if params[:city].present?
    if @ciudad.present?
      cats = ConfigUser.where(activo: 1, ciudad: @ciudad).distinct.pluck(:category_id)
    else
      cats = ConfigUser.where(activo: 1).distinct.pluck(:category_id)
    end
    @categorias = Category.where(id: cats)
    
    @categorias.each do |cat|
      if @ciudad.present?
        negocios = ConfigUser.where(category_id: cat.id, activo: 1, ciudad: @ciudad)
      else
        negocios = ConfigUser.where(category_id: cat.id, activo: 1)
      end
      item = {
        id: cat.id,
        nombre: cat.name,
        negocios: negocios
      }
      @negocios.push(item)
    end
  end

  def error
    if current_user.present? 
      redirect_to me_path and return
    else
      render :layout => nil
    end
  end

  def cuenta
    @config_user = ConfigUser.find_or_create_by(user_id: current_user.id)
    @categorias = Category.all.order("name")
    @link_recomendado = generar_link_recomendado(@config_user)
    @formas_pago = [["Efectivo", "1"] , ["Tarjetas", "2"], ["Efectivo y Tarjetas", "3"]]
    @tipos_entrega = [["A domicilio", "1"] , ["Para recoger", "2"], ["A domicilio y recoger", "3"]]
    @facturacion = [["Si", "Si"] , ["No", "No"]]
    @vista = [["Si", "true"] , ["No", "false"]]
    @estados = Estado.select(:estado).distinct.order(:estado)
    @ciudades = Estado.all.order(:ciudad)
    @bancos = [["Banco Azteca", "Banco Azteca"] , ["Banorte", "Banorte"], ["Bancoppel", "Bancoppel"], ["Banregio", "Banregio"], ["BBVA Bancomer", "BBVA Bancomer"], ["Citibanamex", "Citibanamex"], ["HSBC", "HSBC"], ["Santander", "Santander"], ["Scotiabank", "Scotiabank"]]
  end

  def plan
    @config_user = ConfigUser.find_by(user_id: current_user.id)
    @suspendida = cuenta_suspendida()
    if @config_user.present?
      @plan = Plan.find(@config_user.plan_id)
      @estatus = @config_user.estatus == 1 ? "Vigente" : "Vencido"
    end
  end

  private
  def generar_link_recomendado(user)
    b64_id = Base64.encode64("#{user.id}-pideloencasa.mx")
    if Rails.env.production?
      link = "https://pideloencasa.mx/registro?ref=#{b64_id}"
    else
      link = "http://localhost:3000/registro?ref=#{b64_id}"
    end
    return link
  end
end
