class AddSlugToConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :slug, :string, after: :activo, unique: true
    add_index :config_users, :slug, unique: true
  end
end
