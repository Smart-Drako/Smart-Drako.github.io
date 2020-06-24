class AddDescr2ToProductos < ActiveRecord::Migration[5.2]
  def change
    add_column :productos, :descripcion2, :string, after: :descripcion
  end
end
