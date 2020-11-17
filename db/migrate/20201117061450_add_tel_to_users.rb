class AddTelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :telefono, :string, after: :apellido, unique: true
    add_index :users, [:telefono], unique: true
  end
end
