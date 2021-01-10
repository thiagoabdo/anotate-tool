class AttrValue < ApplicationRecord
  belongs_to :observation
  has_many :notations, dependent: :destroy
  has_many :ml_notations, dependent: :destroy
end
