class CreateMlFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :ml_features do |t|
      t.belongs_to :entry
      t.string :feature

      t.timestamps
    end
  end
end
