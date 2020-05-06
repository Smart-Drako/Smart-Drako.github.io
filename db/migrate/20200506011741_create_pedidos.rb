class CreatePedidos < ActiveRecord::Migration[5.2]
  def change
    create_table :pedidos do |t|
      t.references :user, foreign_key: true
      t.integer :cliente_id
      t.string :cliente_nombre
      t.string :cliente_telefono
      t.string :cliente_direccion
      t.string :area_entrega
      t.string :cliente_horario
      t.string :cliente_metodo_pago
      t.boolean :cliente_factura
      t.string :cliente_rfc
      t.string :cliente_uso_cfdi
      t.string :cliente_email
      t.string :fecha
      t.string :estatus
      t.string :total

      t.timestamps
    end
  end
end
