# frozen_string_literal: true

module Authegy
  module Authorization
    #= Authegy::Authorization::AccessHelpers
    #
    # Methods that deal with defining access to resources by user roles
    module AccessHelpers
      extend ActiveSupport::Concern

      module ClassMethods
        def authorize_access_for(*args)
          ensure_access_authorization_rules_are_initialized
          
          return unless added_rules = add_rules_from_args(*args)
          restrictable_class = added_rules.map(&:restrictable_class).uniq.last

          ensure_authorization_callbacks_are_configured
          ensure_authorized_scope_helper_is_available_for restrictable_class
        end

        private

        def add_rules_from_args(*args)
          rule_attributes = build_rule_attributes_from_args(*args)
          return unless rule_attributes.present?
          access_authorization.add rule_attributes
        end

        def build_rule_attributes_from_args(*args)
          options = args.last.is_a?(Hash) ? args.pop : {}
          restrictable_class = options[:to]
          # Access rules are useless without a class to restrict access to:
          return unless restrictable_class.present?

          {
            subject_path: options.fetch(:of, nil),
            restrictable_class: restrictable_class,
            subjects: Helpers.normalize_items_on_dsl(args)
          }
        end

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
