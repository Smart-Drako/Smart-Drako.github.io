class AddRepartoToPedido < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :reparto, :string, after: :pago_con
  end
end
