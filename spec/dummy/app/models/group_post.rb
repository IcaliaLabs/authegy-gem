class GroupPost < ApplicationRecord
  belongs_to :group,  class_name: 'UserGroup', inverse_of: :posts
  belongs_to :author, class_name: 'Person',    inverse_of: :posts
end
