class Observation < ApplicationRecord
  belongs_to :dataset
  has_many :attr_values, dependent: :destroy
  has_many :notations, dependent: :destroy
end
