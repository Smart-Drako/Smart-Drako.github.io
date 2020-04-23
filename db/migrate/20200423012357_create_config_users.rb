class CreateConfigUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :config_users do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.string :nombre
      t.string :slogan
      t.string :descripcion
      t.string :direccion
      t.string :pagina
      t.string :facebook
      t.string :whatsapp
      t.string :telefono
      t.string :horario
      t.text :condiciones_higiene
      t.string :tipo_entrega
      t.string :costo_envio
      t.string :compra_minima
      t.string :metodo_pago
      t.string :factura

      t.timestamps
    end
  end
end
