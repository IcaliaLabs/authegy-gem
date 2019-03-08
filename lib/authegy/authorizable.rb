# frozen_string_literal: true

module Authegy
  #= Authegy::Authorizable
  #
  # Methods applied to the "authorizable" model - The Person model.
  module Authorizable
    extend ActiveSupport::Concern

    included do
      has_many :role_assignments,
               class_name: '::RoleAssignment',
               inverse_of: :actor,
               foreign_key: :actor_id

      has_many :assigned_roles,
               -> { distinct },
               through: :role_assignments,
               source: :role
    end

    def assign_role(role_name, resource_type_or_instance = nil)
      assignment_attributes = {
        role: ::Role.find_or_create_by(name: role_name)
      }

      if resource_type_or_instance.present?
        assignment_attributes.merge! Authegy
          .extract_resource_attributes(resource_type_or_instance)
      end

      role_assignments.find_or_create_by assignment_attributes
    end

    def has_role?(role_name, resource_type_or_instance = nil)
      role_to_match = role_name.to_s

      return role_assignments_having_role(role_to_match).any? \
        if resource_type_or_instance.blank?

      attributes_to_match = Authegy.extract_resource_attributes(
        resource_type_or_instance
      ).merge! role: role_to_match

      role_assignments_having_attributes(attributes_to_match).any?
    end

    private

    def role_assignment_list
      @role_assignment_list ||= role_assignments.includes(:role).map do |assgn|
        assgn.attributes.slice('resource_type', 'resource_id').merge!(
          role: assgn.role.name
        ).symbolize_keys!
      end
    end

    def role_assignments_having_role(role_to_match)
      role_assignment_list.select do |assignment|
        assignment[:role] == role_to_match
      end
    end

    def role_assignments_having_attributes(attributes_to_match)
      role_assignment_list.select do |assignment|
        assignment == attributes_to_match
      end
    end
  end
end
