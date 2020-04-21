class Entry < ApplicationRecord
  belongs_to :dataset
  has_many :notations
end
