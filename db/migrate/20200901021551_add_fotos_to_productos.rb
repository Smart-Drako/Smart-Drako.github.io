class AddFotosToProductos < ActiveRecord::Migration[5.2]
  def change
    change_column :productos, :foto, :json
  end
end