class PedidoMailer < ApplicationMailer
  def pedido(destinatario, pedido, empresa, vendedor = true)

    @empresa = empresa.nombre
    @pedido = pedido
    @es_proveedor = vendedor
    if vendedor == true
      @destinatario_mensaje = "Tienes un nuevo pedido."
      @destinatario_nombre = @empresa
      asunto = "Nuevo pedido de #{pedido.cliente_nombre} (##{pedido.id})"
    else
      @destinatario_mensaje = "Realizaste un pedido a #{@empresa}"
      @destinatario_nombre = pedido.cliente_nombre
      asunto = "Pedido a #{@empresa} (##{pedido.id})"
    end

    #Variables
    @pedido_numero = pedido.id.to_s.rjust(6, "0")
    @pedido_fecha = pedido.fecha
    @pedido_total = pedido.total
    @info_cliente = "Informacion del cliente (nombre, dir, telefono ,etc."
    @info_proveedor = "Informacion del proveedor (nombre, dir, telefono ,etc."

    @lista_pedido = ProductoPedido.where(pedido_id: pedido.id)

    mail(from: I18n.transliterate("#{@empresa} <pideloencasamx@gmail.com>"), to: I18n.transliterate(destinatario), subject: asunto,  reply_to: '<pideloencasamx@gmail.com>')
  end
end
