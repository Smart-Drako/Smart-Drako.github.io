class PedidosController < ApplicationController
  def generar
    params.permit(:negocio_id, :productos, :total)
    negocio_id = params[:negocio_id].to_i
    total = params[:total].to_f
    productos = JSON.parse(params[:productos])
    if negocio_id.present? && productos.present?
      pedido = Pedido.new
      pedido.user_id = negocio_id
      pedido.total = total
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
    end
  end
end
