admin = Person
          .create_with(first_name: 'Example', last_name: 'Administrator')
          .find_or_create_by email: 'admin@example.com'

admin.assign_role :administrator

member_one = Person
              .create_with(first_name: 'Example One', last_name: 'Member')
              .find_or_create_by email: 'member1@example.com'

member_two = Person
              .create_with(first_name: 'Example Two', last_name: 'Member')
              .find_or_create_by email: 'member2@example.com'

member_three = Person
                 .create_with(first_name: 'Example Three', last_name: 'Member')
                 .find_or_create_by email: 'member3@example.com'

group_one = UserGroup
              .create_with(owner: admin)
              .find_or_create_by name: 'Example Group 1'

member_one.assign_role :member, group_one

group_two = UserGroup
              .create_with(owner: admin)
              .find_or_create_by name: 'Example Group 2'

member_two.assign_role :member, group_two

member_three.assign_role :moderator, group_two

[[group_one, member_one], [group_two, member_two]].each do |group, member|
  group.posts.create! title: 'Example Post 1', author: member
end

[admin, member_one, member_two, member_three].each do |person|
  person.create_user! password: '123456' unless person.user.present?
end

