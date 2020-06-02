class AddTipoEnvioToPedido < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :cliente_tipo_envio, :string, after: :cliente_metodo_pago
  end
end