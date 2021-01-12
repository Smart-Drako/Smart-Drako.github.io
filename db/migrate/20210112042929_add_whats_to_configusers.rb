class AddWhatsToConfigusers < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :recibir_whatsapp, :boolean, after: :mostrar_direccion, default: false
  end
end
