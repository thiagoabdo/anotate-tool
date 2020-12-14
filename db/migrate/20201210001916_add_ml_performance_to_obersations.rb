class AddMlPerformanceToObersations < ActiveRecord::Migration[6.0]
  def change
    add_column :observations, :accuracy, :float
    add_column :observations, :f1_score, :float
    add_column :observations, :last_run, :timestamp
    add_column :observations, :k_fold, :integer
    add_column :observations, :interactive_learn, :boolean
    add_column :observations, :active_learn, :boolean
  end
end
