# frozen_string_literal: true

module Authegy
  module Authorization
    # = Authegy::Authorization::Helper
    #
    # Methods that deal with defining access to resources by user roles
    module Helpers
      extend ActiveSupport::Concern

      CALLBACKS = %i[run_resource_authorization].freeze

      included do
        include Authegy::Authorization::AccessHelpers
      end

      # :nodoc:
      # Reek complains about multiple calls to `request.env` and/or not refering
      # to object state...
      define_method(:auth_request_env) { request.env }

      define_method(:current_user_roles) { current_user.roles }
      define_method(:authorized_roles) { auth_request_env['authorized_roles'] }
      #
      # def match_roles_on
      #   auth_request_env['match_roles_on']
      # end

      def self.parse_given_roles(given_roles = [])
        given_roles = [:administrator] unless given_roles.any?
        options = given_roles.last.is_a?(Hash) ? given_roles.pop.with_indifferent_access : {}
        [given_roles, options]
      end

      # :nodoc: Taken from IcaliaLabs/foresight
      def reduce_scope_by_authorization(scope)
        return scope unless must_match_user_roles?
        scope.scoped_by_user_roles allowed_roles, match_roles_on
      end

      def must_match_user_roles?
        allowed_roles.present? && match_roles_on.present?
      end

      def self.normalize_items_on_dsl(item_list)
        return [item_list.to_s.singularize] if item_list.is_a? Symbol
        return item_list.map(&:to_s).map(&:singularize) if item_list.is_a? Array
        []
      end

      module ClassMethods
        private

        def authorization_callbacks_configured?
          __callbacks[:process_action].each do |callback|
            next unless callback.kind == :before && callback.filter.in?(CALLBACKS)
            return true
          end
          false
        end

        def ensure_authorization_callbacks_are_configured
          return if authorization_callbacks_configured?
          before_action *CALLBACKS
        end
      end

      def current_person_scope
        Person.where(id: current_user.id)
      end

      private

      def raise_unauthorized_error
        raise ActionErrors::Forbidden
      end
    end
  end
end
