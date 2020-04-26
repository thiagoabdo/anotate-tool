class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :roles
  has_many :datasets, through: :roles
  has_many :notations

  scope :users_of_dataset, ->(id) { joins(:roles).merge(Role.all_of(id))}

end
