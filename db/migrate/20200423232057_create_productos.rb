class CreateProductos < ActiveRecord::Migration[5.2]
  def change
    create_table :productos do |t|
      t.references :user, foreign_key: true
      t.string :codigo
      t.string :inventario
      t.string :categoria
      t.string :descripcion
      t.string :unidad
      t.string :precio
      t.string :impuesto

      t.timestamps
    end
  end
end
