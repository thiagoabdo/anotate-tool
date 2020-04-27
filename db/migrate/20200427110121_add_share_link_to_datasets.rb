class AddShareLinkToDatasets < ActiveRecord::Migration[6.0]
  def change
    add_column :datasets, :share_link, :string, unique: true
  end
end
