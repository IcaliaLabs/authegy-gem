# frozen_string_literal: true

module Authegy
  module Authorization
    #= Authegy::Authorization::AccessHelpers
    #
    # Methods that deal with defining access to resources by user roles
    module AccessHelpers
      extend ActiveSupport::Concern

      module ClassMethods
        delegate :normalize_items_on_dsl, to: Helpers
        def authorize_access_for(*associated_roles, **options)
          raise ArgumentError, 'missing keyword: to' unless options.key? :to

          # Access rules won't make sense without a class to restrict:
          return if (restrictable_class = options[:to]).blank?

          # We must assume that access is being given to everybody if no
          # associated roles were given:
          associated_roles = [:everybody] if associated_roles.empty?
          associated_resource = options.fetch :of, restrictable_class

          access_authorization
            .add subject_path: associated_roles,
                 restrictable_class: restrictable_class,
                 subjects: normalize_items_on_dsl(associated_roles)

        def ensure_access_authorization_rules_are_initialized
          mattr_reader :access_authorization,
                       default: Authegy::Authorization::AccessRuleSet.new
        end

        def ensure_authorized_scope_helper_is_available_for(restrictable_class)
          helper_name = \
            "authorized_#{restrictable_class.name.underscore.pluralize}".to_sym
          return if respond_to? helper_name

          define_method(helper_name) { authorized_scope_for restrictable_class }
        end
      end

      private

      def authorized_scope_for(restrictable_class)
        scope = restrictable_class.all

        if (authorization_joins = access_authorization.joins_for(restrictable_class))
          scope = scope.joins(authorization_joins)
        end

        scope.distinct.where access_authorization.conditions_for(
          restrictable_class, current_user&.id
        )
      end

      def run_resource_authorization
        # If no configuration was set, we then assume that the resource is
        # available to everybody:
        return if access_authorization.empty?

        authenticate_user!
        return if current_person_scope.having_role(:administrator).any?
        true
      end
    end
  end
end
