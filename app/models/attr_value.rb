class AttrValue < ApplicationRecord
  belongs_to :observation
  has_many :notations
end
