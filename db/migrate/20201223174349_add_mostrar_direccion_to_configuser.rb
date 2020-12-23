class AddMostrarDireccionToConfiguser < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :mostrar_direccion, :boolean, after: :reparto_activo, default: false
  end
end
