class CreateAttributes < ActiveRecord::Migration[6.0]
  def change
    create_table :attributes do |t|
      t.string :name
      t.belongs_to :dataset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
