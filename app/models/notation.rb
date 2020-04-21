class Notation < ApplicationRecord
  belongs_to :attr_value
  belongs_to :user
  belongs_to :entry
  belongs_to :observation
end
