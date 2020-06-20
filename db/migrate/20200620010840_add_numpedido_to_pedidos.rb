class AddNumpedidoToPedidos < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :numero, :integer, after: :user_id
  end
end
