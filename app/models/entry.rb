class Entry < ApplicationRecord
  belongs_to :dataset, optional: true
  has_many :notations

  require 'csv'
  def self.import(file, id)
    CSV.foreach(file.path, headers:false) do |row|
      Entry.create!({:text => row[0], :dataset_id => id})
    end
  end
end
