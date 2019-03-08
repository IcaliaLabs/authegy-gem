# frozen_string_literal: true

module Authegy
  module Authorization
    # = Authegy::Authorization::ActionHelpers
    #
    # Methods that deal with defining access to resources by user roles
    module ActionHelpers
      extend ActiveSupport::Concern

      included do
        mattr_accessor :action_authorization, default: {}
      end

      module ClassMethods
        # Configures the access rules to controller actions:
        # NOTE: Maybe I've got something else in mind for RESTAPI controllers...
        # ...something dealing with the fact that most RESTAPI controllers deal
        # with the same kind of resource, maybe the `of` parameter may not be
        # required...
        def authorize_action(*actions, **options)
          options = actions.last.is_a?(Hash) ? actions.pop : {}

          roles_on_statement = Helpers
            .normalize_items_on_dsl options.fetch(:to, :anyone)

          resources_on_statement = Helpers
            .normalize_items_on_dsl options.fetch(:of, nil)

          actions.map(&:to_s).each do |action_name|
            (action_authorization[action_name] ||= {}).tap do |action_cfg|
              roles_on_statement.each do |role|
                action_cfg[role] ||= []
                action_cfg[role].concat(resources_on_statement).compact!&.uniq!
              end
            end
          end

          ensure_authorization_callbacks_are_configured
        end

        alias authorize_actions authorize_action
      end

      private

      def run_action_authorization
        return unless action_name.in? action_authorization.keys
        action_config = action_authorization.fetch action_name

        true
      end
    end
  end
end
