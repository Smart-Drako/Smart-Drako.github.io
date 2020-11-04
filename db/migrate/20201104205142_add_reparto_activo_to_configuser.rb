class AddRepartoActivoToConfiguser < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :reparto_activo, :boolean, after: :reparto, default: false
  end
end
