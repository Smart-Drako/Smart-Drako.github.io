class CreateEstados < ActiveRecord::Migration[5.2]
  def change
    create_table :estados do |t|
      t.string :estado
      t.string :ciudad
      t.timestamps
    end
  end
end
