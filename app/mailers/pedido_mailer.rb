class PedidoMailer < ApplicationMailer
  def pedido(destinatario, pedido, empresa, vendedor = true)

    @empresa = empresa.nombre
    @info_empresa = empresa
    @pedido = pedido
    usuario = User.find(empresa.user_id)

    b64_id = Base64.encode64("#{pedido.id}-pideloencasa.mx")
    if Rails.env.production?
      @link = "https://pideloencasa.mx/ver_pedido/#{b64_id}"
    else
      @link = "http://localhost:3000/ver_pedido/#{b64_id}"
    end
    
    @es_proveedor = vendedor
    if vendedor == true
      @destinatario_mensaje = "Tienes un nuevo pedido."
      @destinatario_nombre = @empresa
      asunto = "Nuevo pedido de #{pedido.cliente_nombre} (##{pedido.numero.to_s.rjust(4, "0")})"
    else
      @destinatario_mensaje = "Realizaste un pedido a #{@empresa}"
      @destinatario_nombre = pedido.cliente_nombre
      asunto = "Pedido a #{@empresa} (##{pedido.numero.to_s.rjust(4, "0")})"
    end

    #Variables
    @pedido_numero = pedido.numero.to_s.rjust(4, "0")
    @pedido_fecha = pedido.fecha
    @pedido_total = pedido.total
    @info_cliente = "Informacion del cliente (nombre, dir, telefono ,etc."
    @info_proveedor = "Informacion del proveedor (nombre, dir, telefono ,etc."

    @lista_pedido = ProductoPedido.where(pedido_id: pedido.id)

    mail(from: I18n.transliterate("#{@empresa} <no-reply@pideloencasa.mx>"), to: I18n.transliterate(destinatario), subject: asunto,  reply_to: "<#{usuario.email}>")
  end
end
