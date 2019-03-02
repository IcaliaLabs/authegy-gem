# frozen_string_literal: true

module Authegy
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
      matching_attributes = { role: role_name.to_s }

      return role_assignment_list.select do |assignment|
        assignment[:role] == matching_attributes[:role]
      end.any? if resource_type_or_instance.blank?

      matching_attributes.merge! Authegy
          .extract_resource_attributes(resource_type_or_instance)

      role_assignment_list.select do |assignment|
        assignment == matching_attributes
      end.any?
    end

    private

    def role_assignment_list
      @role_assignment_list ||= role_assignments.includes(:role).map do |assgn|
        assgn.attributes.slice('resource_type', 'resource_id').merge!(
          role: assgn.role.name
        ).symbolize_keys!
      end
    end
  end
end
