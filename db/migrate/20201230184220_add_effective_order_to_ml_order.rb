class AddEffectiveOrderToMlOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :ml_orders, :effective_order, :integer
  end
end
