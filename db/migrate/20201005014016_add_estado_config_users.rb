class AddEstadoConfigUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :estado, :string, after: :pedidos_restantes
    add_column :config_users, :ciudad, :string, after: :estado
  end
end
