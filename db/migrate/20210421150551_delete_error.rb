class DeleteError < ActiveRecord::Migration[6.0]
  def up
    ds =  Dataset.all
    ds.each do |d|
      obs = d.observations
      nts = Notation.where(:observation_id => obs)
      nts.each do |n|
        if n.entry.dataset != d then
          n.destroy
          #p n
        end
      end
      mls = MlOrder.where(:observation_id => obs)
      mls.each do |m|
        if m.entry.dataset != d then
          m.destroy
          #p m
        end
      end
    end
  end
  def down 
  end
end
