class PedidosController < ApplicationController
  before_action :authenticate_user!, :except => [:generar, :new]

  def index
    @pedidos = Pedido.where(user_id: current_user.id)
  end

  def new
  end

  def show
    @pedido = Pedido.find_by(id: params[:id])
    if @pedido.present?
      @productos = ProductoPedido.where(pedido_id: @pedido.id)
      redirect_to pedidos_path and return if @pedido.user_id != current_user.id
    else
      redirect_to pedidos_path and return
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
      pedido.cliente_rfc = cliente["rfc"] if cliente["rfc"].present?
      pedido.cliente_uso_cfdi = cliente["uso_cfdi"] if cliente["uso_cfdi"].present?
      pedido.cliente_email = cliente["correo"] if cliente["correo"].present?

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
  def enviar_correo(email, pedido, empresa)
    #Enviar a la empresa
    user = User.find(empresa.user_id)
    PedidoMailer.pedido(user.email, pedido, empresa, true).deliver if user.present?
    #Enviar al comprador
    PedidoMailer.pedido(email, pedido, empresa, false).deliver if email.present?
  end
end
