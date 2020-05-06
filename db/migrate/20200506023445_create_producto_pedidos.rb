class CreateProductoPedidos < ActiveRecord::Migration[5.2]
  def change
    create_table :producto_pedidos do |t|
      t.references :pedido, foreign_key: true
      t.integer :producto_id
      t.string :nombre
      t.string :precio
      t.string :cantidad
      t.string :unidad
      t.string :subtotal

      t.timestamps
    end
  end
end
