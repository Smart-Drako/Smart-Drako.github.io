class AddLogoToConfigUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :logo, :string, after: :factura
  end
end
