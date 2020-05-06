class PedidosController < ApplicationController
  before_action :authenticate_user!, :except => [:generar]

  def index
    @pedidos = Pedido.where(user_id: current_user.id)
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
    params.permit(:negocio_id, :productos, :total)
    negocio_id = params[:negocio_id].to_i
    total = params[:total].to_f
    productos = JSON.parse(params[:productos])
    if negocio_id.present? && productos.present?
      pedido = Pedido.new
      pedido.user_id = negocio_id
      pedido.estatus = "Nuevo"
      pedido.total = total
      pedido.fecha = Time.now.strftime("%d/%m/%y")
      pedido.cliente_nombre = "Manuel Pruebas"
      pedido.area_entrega = "Area entra prueba"
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
        render json: {error: false, mensaje: "Pedido procesado correctamente"} and return
      else
        render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
      end
    else
      render json: {error: true, mensaje: "Ocurrio un error al procesar el pedido"} and return
    end
  end
end
