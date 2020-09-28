class PedidosController < ApplicationController
  before_action :authenticate_user!, :except => [:generar, :new, :ver_pedido]

  def index
    @pedidos = Pedido.where(user_id: current_user.id).order(id: :desc)
    usuario = ConfigUser.find_by(user_id: current_user.id)
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

    if pedido.present?
      render json: {error: true, mensaje: "No tiene permiso para editar ese pedido"} and return if pedido.user_id != current_user.id
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
      @negocio = ConfigUser.find_by(user_id: @pedido.user_id)
      @estatus_list = ["Nuevo", "Confirmado", "Entregado", "Cancelado"]
      redirect_to pedidos_path and return if @pedido.user_id != current_user.id
      @mensaje_wa = mensaje_whatsapp(@pedido, false)
      @mensaje_wa_link = mensaje_whatsapp(@pedido, true)
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

  def mensaje_whatsapp(pedido, link = false)
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

    case pedido.estatus
    when "Confirmado"
      "Hola *#{pedido.cliente_nombre}* te confirmamos que hemos recibido tu pedido *#{pedido.numero.to_s.rjust(4, "0")}*. En breve te lo tendremos listo. #{link}"
    when "Entregado"
      "Hola *#{pedido.cliente_nombre}* te informamos que tu pedido *#{pedido.numero.to_s.rjust(4, "0")}* ha sido Entregado, muchas gracias por tu compra.. #{link}"
    when "Cancelado"
      "Hola *#{pedido.cliente_nombre}* lamentamos la cancelación de tu pedido, seguimos a tus órdenes. #{link}"
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
      @negocio = ConfigUser.find_by(user_id: @pedido.user_id)
      @estatus_list = ["Nuevo", "Confirmado", "Entregado", "Cancelado"]
    else
      redirect_to root_path and return
    end
  end

  def generar
    params.permit(:negocio_id, :productos, :total, :cliente)
    cliente = JSON.parse(params[:cliente])
    negocio_id = params[:negocio_id].to_i
    total = params[:total].to_f
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
          item.save
        end
        empresa  = ConfigUser.find(negocio_id)
        restar_creditos(empresa)
        #enviar_correo(cliente["correo"], pedido, empresa) if empresa.present?
        render json: {error: false, mensaje: "Pedido procesado correctamente"} and return
      else
        render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
      end
    else
      render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
    end
  end
  private

  def restar_creditos(empresa)
    empresa.pedidos_restantes = empresa.pedidos_restantes - 1
    empresa.save!
  end

  def enviar_correo(email, pedido, empresa)
    #Enviar a la empresa
    user = User.find(empresa.user_id)
    PedidoMailer.pedido(user.email, pedido, empresa, true).deliver if user.present?
    #Enviar al comprador
    PedidoMailer.pedido(email, pedido, empresa, false).deliver if email.present?
  end
end
