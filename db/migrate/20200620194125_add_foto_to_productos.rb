class AddFotoToProductos < ActiveRecord::Migration[5.2]
  def change
    add_column :productos, :foto, :string, after: :impuesto
  end
end
