class AddRepartoToConfigusers < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :reparto, :string, after: :ciudad
  end
end
