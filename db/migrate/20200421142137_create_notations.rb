class CreateNotations < ActiveRecord::Migration[6.0]
  def change
    create_table :notations do |t|
      t.belongs_to :attr_value, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :entry, null: false, foreign_key: true
      t.belongs_to :attribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
