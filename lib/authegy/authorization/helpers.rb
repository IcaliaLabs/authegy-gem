# frozen_string_literal: true

module Authegy
  module Authorization
    # = Authegy::Authorization::Helper
    #
    # Methods that deal with defining access to resources by user roles
    module Helpers
      extend ActiveSupport::Concern

      CALLBACKS = %i[run_resource_authorization run_action_authorization].freeze

      included do
        include Authegy::Authorization::AccessHelpers
        include Authegy::Authorization::ActionHelpers
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
