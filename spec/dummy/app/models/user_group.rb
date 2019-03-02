class UserGroup < ApplicationRecord
  has_many :posts, class_name: 'GroupPost', inverse_of: :group

  has_many :role_fulfillments,
           class_name: 'RoleAssignment',
           as: :resource

  has_many :roles,
           -> { distinct },
           through: :role_fulfillments,
           source: :role

  has_many :actors,
           -> { distinct },
           through: :role_fulfillments,
           source: :actor
end
