class Attribute < ApplicationRecord
  belongs_to :dataset
  has_many :notations
  has_many :attr_values
end
