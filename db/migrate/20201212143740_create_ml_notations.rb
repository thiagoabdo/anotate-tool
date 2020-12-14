class CreateMlNotations < ActiveRecord::Migration[6.0]
  def change
    create_table :ml_notations do |t|
      t.belongs_to :entry, null: false, foreign_key: true
      t.belongs_to :attr_value, null: false, foreign_key: true
      t.belongs_to :observation, null: false, foreign_key: true
      t.float :certain

      t.timestamps
    end
  end
end
