# frozen_string_literal: true

module Authegy
  #= Authegy::Role
  # A `Role`
  class Role < Authegy::AbstractRecord
    self.table_name = :roles

    validates :name, format: {
      with: /\A[a-z_]+\z/,
      message: 'only allows letters and underscores'
    }

    has_many :assignments, class_name: '::RoleAssignment', inverse_of: :role
    has_many :actors, -> { distinct }, through: :assignments, source: :actor
  end
end
