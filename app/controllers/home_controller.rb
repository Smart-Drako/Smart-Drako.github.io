class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :error, :landing]

  def index

    @page_title = "Inicio"
    usuario = ConfigUser.find_by(user_id: current_user.id) if current_user.present?

    if usuario.present? && usuario.admin == true
      activo = [0,1]
    else
      activo = [1]
    end
    @negocios = Array.new
    @ciudades_negocios = ConfigUser.where(activo: activo).distinct.pluck(:ciudad)
    @ciudad = params[:city] if params[:city].present?
    if @ciudad.present?
      cats = ConfigUser.where(activo: activo, ciudad: @ciudad).distinct.pluck(:category_id)
    else
      cats = ConfigUser.where(activo: activo).distinct.pluck(:category_id)
    end

    #Link para compartir si estoy logueado ver el compartir
    if usuario.present?
      @link_ref =  Base64.encode64("#{usuario.id}-pideloencasa.mx")
      @base_url = Rails.env.production? ? "pideloencasa.mx" : "staging.pideloencasa.mx"
    end
    @categorias = Category.where(id: cats)
    
    @categorias.each do |cat|
      if @ciudad.present?
        negocios = ConfigUser.where(category_id: cat.id, activo: activo, ciudad: @ciudad)
      else
        negocios = ConfigUser.where(category_id: cat.id, activo: activo)
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

  def admin_efra
    usuario = ConfigUser.find_by(user_id: current_user.id) if current_user.present?
    if usuario.present? && usuario.admin == false
      redirect_to me_path and return
    end

    @usuarios = User.find_by_sql("SELECT E.id, E.slug,
      U.email AS correo,U.created_at as fecha_registro, U.nombre, U.apellido, E.nombre AS negocio, E.id as negocio_id
      FROM
      pideloencasa.users AS U
          INNER JOIN
      config_users AS E ON U.id = E.user_id order by U.id desc")

    @lista = Array.new

    @usuarios.each do |u|

      rec = Recomendado.find_by(id_usuario: u.negocio_id)

      link_recomendado = generar_link_recomendado(u)
      link_compartir = generar_link_compartir(u)

      item = {
        "fecha_registro": u.fecha_registro,
        "correo": u.correo,
        "nombre": u.nombre,
        "apellido": u.apellido,
        "nombre_empresa": u.negocio,
        "link_recomendado": link_recomendado,
        "link_compartir": link_compartir,
        "id_empresa": u.negocio_id,
        "papa": (rec.present? ? rec.id_padre : ""),
        "abuelo": (rec.present? ? rec.id_abuelo : ""),
      }
      @lista.push(item)
    end

  end

  def cuenta
    @page_title = "Configuración"
    @config_user = ConfigUser.find_or_create_by(user_id: current_user.id)
    @vencimiento = vencimiento_cuenta(@config_user)
    @categorias = Category.all.order("name")
    @link_recomendado = generar_link_recomendado(@config_user)
    @link_compartir = generar_link_compartir(@config_user)
    @formas_pago = [["Efectivo", "1"] , ["Tarjetas", "2"], ["Efectivo y Tarjetas", "3"]]
    @tipos_entrega = [["A domicilio", "1"] , ["Para recoger", "2"], ["A domicilio y recoger", "3"]]
    @facturacion = [["Si", "Si"] , ["No", "No"]]
    @mostrar_dir = [["Si", "true"] , ["No", "false"]]
    @vista = [["Tipo Cards", "true"] , ["Tipo Lista", "false"]]
    @repartos = [["ZAS Reparto", "ZAS Reparto"]]
    @estados = Estado.select(:estado).distinct.order(:estado)
    @ciudades = Estado.all.order(:ciudad)
    @bancos = [["Banbajío", "Banbajío"],["Banco Azteca", "Banco Azteca"] , ["Banorte", "Banorte"], ["Bancoppel", "Bancoppel"], ["Banregio", "Banregio"], ["BBVA Bancomer", "BBVA Bancomer"], ["Citibanamex", "Citibanamex"], ["HSBC", "HSBC"],["Inbursa","Inbursa"], ["Santander", "Santander"], ["Scotiabank", "Scotiabank"]]
  end

  def landing
    render :layout => nil
  end

  def codigo_qr(id = 0)
    if id == 0
      id = params[:id]
    end
    @empresa = ConfigUser.find(params[:id])
    @qr =  generar_qr(@empresa)
  end

  def descargar_qr
    @empresa = ConfigUser.find(params[:id])
    @qr =  generar_qr(@empresa)
    qr_pdf = crear_qr_pdf(@empresa) if params[:format] == "pdf"
    qr_png = crear_qr_png(@empresa) if params[:format] == "png"
    respond_to do |format|
      format.html
      format.png { send_data qr_png, :filename => 'qr.png', :disposition => "inline",:type => "image/png"}
      format.pdf { send_data qr_pdf, :filename => 'qr.pdf', :disposition => "inline",:type => "application/pdf"}
    end
    # render :layout => nil
  end

  def crear_qr_png(empresa) 
    codigo_qr(empresa)
    kit = IMGKit.new(render_to_string('home/codigo_qr.html.erb', :layout => 'pedido.html.erb'),encoding: 'utf8')
    kit.to_png
  end

  def crear_qr_pdf(empresa)
    codigo_qr(empresa)
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('home/codigo_qr.html.erb', :layout => 'pedido.html.erb'), print_media_type: true,
      margin:  { top: 1, bottom: 10, left: 2, right: 2},
      page_size: "Letter",
      disable_smart_shrinking: false,
      encoding: 'utf8'
        )
    pdf
  end

  def generar_qr(empresa)

    require 'rqrcode'

    link = generar_link_compartir(empresa)
    # link = "https://pideloencasa.mx/socios/Gustavo-Martinez-DeliFruitMercado"

    qrcode = RQRCode::QRCode.new(link)

    # NOTE: showing with default options specified explicitly
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 1,
      color_mode: ChunkyPNG::Color,
      color: '#282828',
      file: nil,
      fill: '#ffffff',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 1024
    )

    png.to_data_url
    
  end

  def plan
    @page_title = "Mi Plan"
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
    elsif Rails.env.staging?
      link = "https://staging.pideloencasa.mx/registro?ref=#{b64_id}"
    else
      link = "http://localhost:3000/registro?ref=#{b64_id}"
    end
    return link
  end
  def generar_link_compartir(user)
    if user.slug.present?
      socio = user.slug
    else
      socio = "#{user.id}-#{user.nombre.to_s.parameterize}"
    end
    if Rails.env.production?
      link = "https://pideloencasa.mx/socios/#{socio}"
    elsif Rails.env.staging?
      link = "https://staging.pideloencasa.mx/socios/#{socio}"
    else
      link = "http://localhost:3000/socios/#{socio}"
    end
    return link
  end
end
