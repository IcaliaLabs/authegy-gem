class GroupPost < ApplicationRecord
  belongs_to :group,
             class_name: 'UserGroup',
             inverse_of: :posts,
             foreign_key: :group_id

  belongs_to :author,
             class_name: 'Person',
             inverse_of: :authored_posts,
             foreign_key: :author_id
end
