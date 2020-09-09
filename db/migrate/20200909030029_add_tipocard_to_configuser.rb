class AddTipocardToConfiguser < ActiveRecord::Migration[5.2]
  def change
    add_column :config_users, :vista_card, :boolean, after: :slug, :null => false, :default => 0
  end
end
