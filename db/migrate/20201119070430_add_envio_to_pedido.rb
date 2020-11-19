class AddEnvioToPedido < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :envio, :string, after: :reparto
  end
end
