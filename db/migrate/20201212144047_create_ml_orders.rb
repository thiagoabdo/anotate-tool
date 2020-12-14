class CreateMlOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :ml_orders do |t|
      t.belongs_to :entry, null: false, foreign_key: true
      t.belongs_to :observation, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
