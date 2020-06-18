class AddActivoToConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :activo, :boolean, after: :logo, default: true
  end
end
