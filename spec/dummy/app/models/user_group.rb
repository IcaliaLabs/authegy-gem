class UserGroup < ApplicationRecord
  belongs_to :owner, class_name: 'Person', inverse_of: :groups

  has_many :posts,
           class_name: 'GroupPost',
           inverse_of: :group,
           foreign_key: :group_id

  has_many :role_assignments,
           class_name: 'RoleAssignment',
           as: :resource

  has_many :roles,
           -> { distinct },
           through: :role_assignments,
           source: :role

  has_many :actors,
           -> { distinct },
           through: :role_assignments,
           source: :actor

  # # Testing if this is possible - it would be VERY cool! We could force people
  # # to the best practice of defining associations:
  # has_many :members,
  #          -> { joins(:assigned_roles).where(Role.arel_table[:name].eq('member')) },
  #          through: :role_assignments,
  #          source: :actor
end
