class CreateGroupPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :group_posts do |t|
      t.references :group,  foreign_key: { to_table: :user_groups }
      t.references :author, foreign_key: { to_table: :people }
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
