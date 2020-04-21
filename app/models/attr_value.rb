class AttrValue < ApplicationRecord
  belongs_to :attribute
  has_many :notations
end
