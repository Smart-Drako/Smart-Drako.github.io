# Preview all emails at http://localhost:3000/rails/mailers/pedido_mailer
class PedidoMailerPreview < ActionMailer::Preview
  def pedido
    PedidoMailer.pedido("manrobless@gmail.com", "Asunto chido")
  end
end