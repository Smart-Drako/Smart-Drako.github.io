class AddPagoConPedidos < ActiveRecord::Migration[5.2]
  def change
    add_column :pedidos, :pago_con, :string, after: :total
  end
end
