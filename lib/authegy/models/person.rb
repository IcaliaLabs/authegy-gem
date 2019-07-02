# frozen_string_literal: true

module Authegy
  # Person holds the "Profile" for a given User, but we can also have just
  # Person profiles without a user, as is the case for "Board Members"
  class Person < ApplicationRecord
    self.abstract_class = true
    
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

      resource_type = resource.nil? ? nil : resource.class.name
      resource_id = resource&.id

      condition_arel = roles[:name]
        .eq(role_name.to_s)
        .and(role_assignments[:resource_type].eq(resource_type))
        .and(role_assignments[:resource_id].eq(resource_id))

      joins(:assigned_roles).where condition_arel
    end
  end
end
