class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups do |t|
      t.string :name
      t.string :description
      t.references :owner, index: true, foreign_key: { to_table: :people }

      t.timestamps
    end
  end
end
