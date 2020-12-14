class MlNotation < ApplicationRecord
  belongs_to :entry
  belongs_to :attr_value
  belongs_to :observation
end
