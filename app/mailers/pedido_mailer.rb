class PedidoMailer < ApplicationMailer
  def pedido(destinatario, asunto)
    @empresa = "Abarrotes La Unica"
    #Variables
    @destinatario_nombre = "Manuel Robles"
    @destinatario_mensaje = "Realizaste un pedido a #{@empresa}"
    @pedido_numero = "1234"
    @pedido_fecha = "14/05/2020"
    @pedido_total = "$345.00"
    @info_cliente = "Informacion del cliente (nombre, dir, telefono ,etc."
    @info_proveedor = "Informacion del proveedor (nombre, dir, telefono ,etc."

    mail(from: I18n.transliterate("#{@empresa} <pideloencasamx@gmail.com>"), to: I18n.transliterate(destinatario), subject: asunto,  reply_to: '<pideloencasamx@gmail.com>')
  end
end
