class AddComentarioAvisoConfiguser < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :aviso, :string, after: :banco
    add_column :config_users, :comentario, :string, after: :aviso
  end
end
