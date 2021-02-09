class AddEmbajadorPedidos < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :id_embajador, :int, after: :cliente_id
  end
end
