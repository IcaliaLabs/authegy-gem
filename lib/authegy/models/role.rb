# frozen_string_literal: true

module Authegy
  # A `Role`
  class Role < ActiveRecord::Base
    self.table_name = :roles

    validates :name, format: {
      with: /\A[a-z_]+\z/,
      message: 'only allows letters and underscores'
    }

    has_many :role_assignments,
             class_name: 'Authegy::RoleAssignment',
             inverse_of: :role

    has_many :actors,
             -> { distinct },
             through: :role_assignments,
             source: :author
  end
end
