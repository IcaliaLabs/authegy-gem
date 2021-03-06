# frozen_string_literal: true

class CreateAuthegyModelTables < ActiveRecord::Migration[5.2]
  def change
    create_people_table
    create_users_table
    create_roles_table
    create_role_assignments_table
  end

  def create_people_table
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: { unique: true }

      # Feel free to add additional fields, such as 'nickname', etc:
      # t.string :phone

      t.timestamps null: false
    end
  end

  def create_users_table
    create_table :users do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token, index: { unique: true }
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token, index: { unique: true }
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # # Only if lock strategy is :failed_attempts:
      # t.integer  :failed_attempts, default: 0, null: false
      # # Only if unlock strategy is :email or :both:
      # t.string   :unlock_token, index: { unique: true }
      # t.datetime :locked_at

      t.timestamps null: false
    end

    # The `users.id` column is actually a foreign key to the `people` table:
    add_foreign_key :users, :people, column: :id
  end

  def create_roles_table
    create_table :roles do |t|
      t.string :name, null: false, comment: 'Name of the role'
      t.text :description, comment: 'Description of the role'

      t.timestamps null: false
    end
  end

  def create_role_assignments_table
    create_table :role_assignments do |t|
      t.references :actor, foreign_key: { to_table: :people }

      t.references :role,
                   foreign_key: { to_table: :roles },
                   comment: 'The role assigned to the actor'

      t.references :resource, polymorphic: true
    end
  end
end
