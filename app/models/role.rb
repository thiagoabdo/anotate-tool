class Role < ApplicationRecord
  belongs_to :user
  belongs_to :dataset

  scope :owned_by, ->(id) { where(user_id: id, role: 0) }
  scope :owners_of, ->(id) { where(dataset_id: id, role: 0)}

  scope :anotator_by, ->(id) { where(user_id: id, role: 1) }
  scope :anotator_of, ->(id) { where(dataset_id: id, role: 1)}
end
