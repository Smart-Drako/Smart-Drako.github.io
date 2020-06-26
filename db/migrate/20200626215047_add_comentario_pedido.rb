class AddComentarioPedido < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :comentario, :string, after: :cliente_email
  end
end
