class Roles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :dataset, foreign_key: true, null: false
      t.binary :role, null: false
      t.timestamps
    end
  end
end
