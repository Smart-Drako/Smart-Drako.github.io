class CreatePlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :planes do |t|
      t.string :nombre #Prueba gratis, Plan visionario
      t.integer :no_pedidos #100, 6000 (ilim)
      t.string :precio #99 299 
      t.string :precio_iva #108.14
      t.integer :vigencia #30 365
      t.boolean :ilimitado #0/1
      t.timestamps
    end
  end
end
