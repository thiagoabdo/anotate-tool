class CreateAttrValues < ActiveRecord::Migration[6.0]
  def change
    create_table :attr_values do |t|
      t.string :value
      t.belongs_to :attribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
