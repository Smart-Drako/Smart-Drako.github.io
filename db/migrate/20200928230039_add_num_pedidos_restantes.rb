class AddNumPedidosRestantes < ActiveRecord::Migration[5.2]
  def change
    #Numero de pedidos restantes
    add_column :config_users, :pedidos_restantes, :integer, after: :admin, :null => false, :default => 0
  end
end
