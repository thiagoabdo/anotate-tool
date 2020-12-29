class AddMinNotationsToObservations < ActiveRecord::Migration[6.0]
  def change
    add_column :observations, :min_notations, :integer
  end
end
