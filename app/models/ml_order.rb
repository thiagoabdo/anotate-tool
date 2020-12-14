class MlOrder < ApplicationRecord
  belongs_to :entry
  belongs_to :observation
end
