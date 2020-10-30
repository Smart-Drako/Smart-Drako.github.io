class AddNotaRepPedidos < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :nota_repartidor, :string, after: :reparto
  end
end
