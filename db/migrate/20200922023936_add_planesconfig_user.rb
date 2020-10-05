class AddPlanesconfigUser < ActiveRecord::Migration[5.2]
  def change
    #Estatus: activo 1 /suspendido 2
    add_column :config_users, :estatus, :integer, after: :vista_card
    #Fecha Registro
    add_column :config_users, :fecha_registro, :datetime, after: :estatus
    #Fecha Inicio Pago
    add_column :config_users, :fecha_inicio, :datetime, after: :fecha_registro
    #Fecha Vencimiento
    add_column :config_users, :fecha_vencimiento, :datetime, after: :fecha_inicio
    #Plan
    add_reference :config_users, :plan, foreign_key: false, after: :fecha_vencimiento
    #Administrador
    add_column :config_users, :admin, :boolean, after: :plan_id, :null => false, :default => 0
  end
end
