class AddApellidoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apellido, :string, after: :nombre
  end
end
