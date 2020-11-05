class PedidosController < ApplicationController
  before_action :authenticate_user!, :except => [:generar, :new, :ver_pedido, :calcular_envio]
  include ActionView::Helpers::NumberHelper
  def index
    usuario = ConfigUser.find_by(user_id: current_user.id)
    @pedidos = Pedido.where(user_id: usuario.id).order(id: :desc)
    @vencimiento = vencimiento_cuenta(usuario)
    @pedidos_restantes = usuario.pedidos_restantes
    @suspendida = cuenta_suspendida()
    @estatus_list = ["Nuevo", "Confirmado", "Entregado", "Cancelado"]
  end

  def new
  end

  def actualizar_estatus
    pedido_id = params[:pedido_id].to_i
    estatus = params[:estatus]
    pedido = Pedido.find(pedido_id)
    usuario = ConfigUser.find_by(user_id: current_user.id)

    if pedido.present?
      render json: {error: true, mensaje: "No tiene permiso para editar ese pedido"} and return if pedido.user_id != usuario.id
      pedido.estatus = estatus
      if pedido.save!
        render json: {error: false, mensaje: "Pedido actualizado correctamente"} and return
      else
        render json: {error: true, mensaje: "Ocurrió un error al actualizar el pedido"} and return
      end
    else
      render json: {error: true, mensaje: "No se encontró el pedido"} and return
    end

  end

  def show(id = 0)
    if cuenta_suspendida
      redirect_to pedidos_path and return
    end
    if id == 0
      id = params[:id]
    end
    @pedido = Pedido.find_by(id: id)
    if @pedido.present?
      @productos = ProductoPedido.where(pedido_id: @pedido.id)
      @negocio = ConfigUser.find(@pedido.user_id)
      redirect_to pedidos_path and return if @pedido.user_id != @negocio.id
      
      if @negocio.reparto == "ZAS Reparto" && @pedido.reparto.present? && @pedido.reparto.to_f > 0
        @estatus_list = ["Nuevo", "Confirmado","ZAS Reparto","Enviada a ZAS","Entregado", "Cancelado"]
      else
        @estatus_list = ["Nuevo", "Confirmado", "Entregado", "Cancelado"]
      end

      @estatus_list = ["Enviada a ZAS", "Entregado"] if @pedido.estatus == "Enviada a ZAS"
    

      # if @pedido.reparto.present? && @pedido.estatus == "ZAS Reparto" && @pedido.reparto.to_f > 0
      #   @mensaje_wa = mensaje_whatsapp(@pedido, false, true)
      #   @mensaje_wa_link = mensaje_whatsapp(@pedido, true, true)
      # else
      @mensaje_wa = mensaje_whatsapp(@pedido, false, @negocio, nil)
      @mensaje_wa_link = mensaje_whatsapp(@pedido, true, @negocio, nil)
      # end

      @link_pedido = link_pedido(@pedido)
      @link_wa_base = "https://api.whatsapp.com/send?phone=52#{@pedido.cliente_telefono}&text="
      @link_wa = "https://api.whatsapp.com/send?phone=52#{@pedido.cliente_telefono}&text=#{@mensaje_wa_link}"
    else
      redirect_to pedidos_path and return
    end
  end

  def link_pedido(pedido)
    b64_id = Base64.encode64("#{pedido.id}-pideloencasa.mx")
    if Rails.env.production?
      link = "https://pideloencasa.mx/ver_pedido/#{b64_id}"
    elsif Rails.env.staging?
      link = "http://staging.pideloencasa.mx/ver_pedido/#{b64_id}"
    else
      link = "http://localhost:3000/ver_pedido/#{b64_id}"
    end
    return link
  end

  def mensaje_whatsapp(pedido, link = false, negocio, nota)
    b64_id = Base64.encode64("#{pedido.id}-pideloencasa.mx")
    if link == true
      if Rails.env.production?
        link = "https://pideloencasa.mx/ver_pedido/#{b64_id}"
      else
        link = "http://localhost:3000/ver_pedido/#{b64_id}"
      end
    else
      link = ""
    end

    paga_con = pedido.pago_con.present?  ? number_to_currency(pedido.pago_con, :precision => 2) :  "N/A"
    nota_rep = nota.present?  ? nota :  "N/A"

    case pedido.estatus
    when "Confirmado"
      "Hola *#{pedido.cliente_nombre}* te confirmamos que hemos recibido tu pedido *#{pedido.numero.to_s.rjust(4, "0")}*. En breve te lo tendremos listo. #{link}"
    when "Entregado"
      "Hola *#{pedido.cliente_nombre}* te informamos que tu pedido *#{pedido.numero.to_s.rjust(4, "0")}* ha sido Entregado, muchas gracias por tu compra. #{link}"
    when "Cancelado"
      "Hola *#{pedido.cliente_nombre}* lamentamos la cancelación de tu pedido, seguimos a tus órdenes. #{link}"
    when "ZAS Reparto"
      "<b>#{negocio.nombre}</b> \n #{negocio.direccion} \n #{negocio.whatsapp} \n * * * * * * \n FAVOR DE REPARTIR A: \n <b>#{pedido.cliente_nombre}</b> \n #{pedido.cliente_telefono} \n #{pedido.cliente_direccion}, #{pedido.area_entrega} \n \n Pedido: #{number_to_currency(pedido.total, :precision => 2)} \n Reparto: #{number_to_currency(pedido.reparto, :precision => 2)} \n Total: #{number_to_currency(pedido.total.to_f + pedido.reparto.to_f, :precision => 2)} \n Paga con: #{paga_con}\n\n Nota Repartidor:\n #{nota_rep}\n\n <a href='#{link}'>Ver Pedido</a>"
    end
  end

  def descargar_pdf
    pedido = Pedido.find_by(id: params[:id])
    pdf = generar_pdf(pedido.id)

    respond_to do |format|
      format.html
      format.pdf { send_data pdf, :filename => pedido.numero.to_s.rjust(4, "0") + '.pdf', :disposition => "inline",:type => "application/pdf"}
    end
  end

  def generar_pdf(id)
    show(id)
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('pedidos/descargar.html.erb', :layout => 'pedido.html.erb'), print_media_type: true,
      margin:  { top: 1, bottom: 10, left: 2, right: 2},
      page_size: "Letter",
      disable_smart_shrinking: false,
      footer: {right: 'Pag. [page] de [topage]', font_size: 8 },
      encoding: 'utf8'
        )
    pdf
  end

  def ver_pedido
    id = Base64.decode64(params[:id]).to_i
    @pedido = Pedido.find_by(id: id)
    if @pedido.present?
      @productos = ProductoPedido.where(pedido_id: @pedido.id)
      @negocio = ConfigUser.find(@pedido.user_id)
      @estatus_list = ["Nuevo", "Confirmado", "Entregado", "Cancelado"]
      @tags = {
        title: @negocio.nombre,
        description: @negocio.descripcion
      }
    else
      redirect_to root_path and return
    end
  end

  def solicitar_reparto
    pedido = Pedido.find_by(id: params[:pedido_id].to_i)
    nota = params[:nota]
    
    if pedido.present?
      negocio = ConfigUser.find(pedido.user_id)
      mensaje = mensaje_whatsapp(pedido, true, negocio, nota)
      #Request
      url = URI.parse("https://api.telegram.org")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      #Params api telegram
      bot = "1438829600:AAH_Ugi1iOgjcM1TeGteVzCKfiPI4vwI4kY"
      chat_id = "466231810"

      request = Net::HTTP::Get.new("/bot#{bot}/sendMessage?chat_id=-#{chat_id}&text=#{URI.escape(mensaje)}&parse_mode=html")
      request["content-type"] = 'application/json'
  
      response = http.request(request)
      json = JSON.parse(response.body)

      if json["ok"] == true
        pedido.estatus = "Enviada a ZAS"
        pedido.save!
        render json: {error: false, mensaje: "Solicitud enviada a ZAS Reparto existosamente, en breve te avisarán cuando vayan en camino."} and return
      else
        render json: {error: true, mensaje:"No se pudo enviar la solicitud a ZAS Reparto"} and return
      end
      
    else
      render json: {error: true, mensaje:"No se pudo enviar la solicitud a ZAS Reparto"} and return
    end


    
    
  end

  def calcular_envio
    origen = params["origen"]
    destino = params["destino"]

    url = URI.parse("https://maps.googleapis.com")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new("/maps/api/directions/json?origin=#{URI.escape(origen)}&destination=#{URI.escape(destino)}&key=AIzaSyBqc9wkluIeSqtMa2mPeMPpmpCqo-Dj1yI")
    request["content-type"] = 'application/json'

    response = http.request(request)
    json = JSON.parse(response.body)

    distancia_valor = ((json["routes"][0]["legs"][0]["distance"]["value"]).to_f / 1000 ).round
    distancia_texto = json["routes"][0]["legs"][0]["distance"]["text"]
    reparto = calcular_reparto(distancia_valor)
    
    render json: {distancia: distancia_valor, distancia_texto: distancia_texto, reparto: reparto} and return
  
  end

  def generar
    params.permit(:negocio_id, :productos, :total, :cliente)
    cliente = JSON.parse(params[:cliente])
    negocio_id = params[:negocio_id].to_i
    total = params[:total].to_f
    reparto = params[:reparto].to_f
    productos = JSON.parse(params[:productos])
    if negocio_id.present? && productos.present?
      pedido = Pedido.new
      pedido.user_id = negocio_id
      pedido.numero = Pedido.proximo_pedido(negocio_id)
      pedido.estatus = "Nuevo"
      pedido.total = total
      pedido.fecha = Time.now.strftime("%d/%m/%Y")
      pedido.cliente_nombre = cliente["nombre"] if cliente["nombre"].present?
      pedido.cliente_telefono = cliente["telefono"] if cliente["telefono"].present?
      pedido.cliente_direccion = cliente["direccion"] if cliente["direccion"].present?
      pedido.area_entrega = cliente["area"] if cliente["area"].present?
      pedido.cliente_horario = cliente["horario"] if cliente["horario"].present?
      pedido.cliente_metodo_pago = cliente["pago"] if cliente["pago"].present?
      pedido.cliente_factura = cliente["factura"] if cliente["factura"].present?
      pedido.cliente_tipo_envio = cliente["tipo_envio"] if cliente["tipo_envio"].present?
      pedido.cliente_rfc = cliente["rfc"] if cliente["rfc"].present?
      pedido.cliente_uso_cfdi = cliente["uso_cfdi"] if cliente["uso_cfdi"].present?
      pedido.cliente_email = cliente["correo"] if cliente["correo"].present?
      pedido.comentario = cliente["comentario"] if cliente["comentario"].present?
      pedido.pago_con = cliente["paga_con"] if cliente["paga_con"].present?
      pedido.reparto = reparto if (reparto.present? && reparto > 0)

      if pedido.save
        productos.each do |p|
          item = ProductoPedido.new
          item.pedido_id = pedido.id
          item.producto_id = p["id"]
          item.nombre = p["nombre"]
          item.cantidad = p["cantidad"]
          item.precio = p["precio"]
          item.subtotal = p["subtotal"]
          item.unidad = p["unidad"]
          if item.save
            descontar_inventario(item)
          end
        end
        empresa  = ConfigUser.find(negocio_id)
        restar_creditos(empresa)
        enviar_correo(cliente["correo"], pedido, empresa) if empresa.present?
        render json: {error: false, mensaje: "Pedido procesado correctamente"} and return
      else
        render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
      end
    else
      render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
    end
  end
  private
  
  def calcular_reparto(distancia_valor) # 14.4
    case distancia_valor.to_i
    when 0..4
      40
    when 5
      45
    when 6
      50
    when 7
      55
    when 8
      60
    when 9
      65
    when 10
      70
    when 11
      75
    when 12
      80
    when 13
      85
    when 14
      90
    when 15
      95
    else
      100
    end

  end
  def restar_creditos(empresa)
    empresa.pedidos_restantes = empresa.pedidos_restantes - 1
    empresa.save!
  end

  def descontar_inventario(item)
    cant = item.cantidad.to_i
    prod = Producto.find(item.producto_id)
    if prod.present? && prod.inventario.present?
      prod.inventario = prod.inventario.to_i - cant
      prod.save
    end
  end

  def enviar_correo(email, pedido, empresa)
    #Enviar a la empresa
    user = User.find(empresa.user_id)
    PedidoMailer.pedido(user.email, pedido, empresa, true).deliver if user.present?
    #Enviar al comprador
    PedidoMailer.pedido(email, pedido, empresa, false).deliver if email.present?
  end
end
