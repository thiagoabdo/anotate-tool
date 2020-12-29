class ChangeDataTypeForEntrie < ActiveRecord::Migration[6.0]
  def up
    change_column(:ml_features, :feature, :text)
    add_foreign_key(:ml_features, :entries)
  end
  def down
    change_column(:ml_features, :feature, :string)
  end
end
