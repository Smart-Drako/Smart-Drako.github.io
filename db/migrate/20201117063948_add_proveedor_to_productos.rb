class AddProveedorToProductos < ActiveRecord::Migration[5.2]
  def change
    add_column :productos, :proveedor, :string, after: :foto
  end
end
