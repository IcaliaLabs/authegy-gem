# frozen_string_literal: true

module Authegy
  # Person holds the "Profile" for a given User, but we can also have just
  # Person profiles without a user, as is the case for "Board Members"
  class Person < Authegy::AbstractRecord
    include Authegy::Authorizable

    self.table_name = :people
    # Validations from 'validatable':
    validates :email,
              uniqueness: true,
              format: Devise.email_regexp,
              allow_blank: true,
              if: :will_save_change_to_email?

    has_one :user, class_name: '::User', inverse_of: :person, foreign_key: :id

    def self.having_role(role_name, resource = nil)
      roles = ::Role.arel_table
      role_assignments = ::RoleAssignment.arel_table

      condition_arel = roles[:name].eq role_name.to_s

      if resource.nil?
        condition_arel = condition_arel
          .and(role_assignments[:resource_type].eq(nil))
          .and(role_assignments[:resource_id].eq(nil))
      end

      joins(:assigned_roles).where condition_arel
    end
  end
end
