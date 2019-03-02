class CreateGroupPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :group_posts do |t|
      t.references :group, foreign_key: true
      t.references :author, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
