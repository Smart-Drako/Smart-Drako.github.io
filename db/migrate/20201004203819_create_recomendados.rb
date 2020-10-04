class CreateRecomendados < ActiveRecord::Migration[5.2]
  def change
    create_table :recomendados do |t|
      t.integer :id_usuario
      t.integer :id_padre
      t.integer :id_abuelo
      t.timestamps
    end
  end
end
