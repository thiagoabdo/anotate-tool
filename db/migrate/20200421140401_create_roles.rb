class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.binary :role, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :dataset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
