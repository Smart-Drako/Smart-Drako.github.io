class Pedido < ApplicationRecord
  belongs_to :user

  def self.proximo_pedido(user_id)
    pedido = Pedido.where(user_id: user_id).last
    if pedido.present? && pedido.numero.present?
      numero = pedido.numero + 1
    else
      numero = 1
    end
    return numero
  end

end
