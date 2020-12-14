class Notation < ApplicationRecord
  belongs_to :attr_value
  belongs_to :user
  belongs_to :entry
  belongs_to :observation

  scope :from_user_obs, ->(uid,oid) {where(:user_id => uid).where(:observation_id => oid)}
  scope :from_obs, ->(oid) {where(:observation_id => oid)}
end
