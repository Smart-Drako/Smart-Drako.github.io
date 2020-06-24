class AddTransferenciaFieldsConfiguser < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :beneficiario, :string, after: :metodo_pago
    add_column :config_users, :cuenta, :string, after: :beneficiario
    add_column :config_users, :banco, :string, after: :cuenta
  end
end
