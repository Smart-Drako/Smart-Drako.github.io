# Preview all emails at http://localhost:3000/rails/mailers/pedido_mailer
class PedidoMailerPreview < ActionMailer::Preview
  def pedido
    empresa  = ConfigUser.find(1)
    pedido = Pedido.find(47)
    PedidoMailer.pedido("manrobless@gmail.com",pedido, empresa)
  end
end
