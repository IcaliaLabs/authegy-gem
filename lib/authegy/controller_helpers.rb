# frozen_string_literal: true

module Authegy
  # = AuthorizationHelper
  #
  # Methods that deal with defining access to resources by user roles
  module ControllerHelpers
    # authorize_action!
    # Usage:
    # ```
    # class ThingsController < ApplicationController
    #   before_action do
    #     authorize_action! to: 'thing.owner'
    #     authorize_action! :administrator, :manager, of: 'thing.other_thing'
    #     authorize_action! :anyone, from: 'thing.company'
    #   end, only: [:index, :show]
    # end
    # ```
    def authorize_action!(*given_roles)
      given_roles, options = AuthorizationHelper.parse_given_roles(given_roles)
      auth_request_env['match_roles_on'] = options[:match_roles_on] if options.key?(:match_roles_on)

      return auth_request_env['authorized_roles'] = Role.all if super_admin_user?
      auth_request_env['authorized_roles'] = current_user_roles.where(name: given_roles)

      # error if only general manager, plant managers can create

      raise ActionErrors::Forbidden if authorized_roles.map(&:name).count == 1 && current_user_roles.first.name == 'manager' && current_user_roles.where(name: 'manager').where.not(target_id: nil).empty?
      raise ActionErrors::Forbidden unless authorized_roles.any?
    end

    def authorize_action(*given_roles)
      authorize_action!(*given_roles)
    rescue
      false
    end

    def super_admin_user?
      auth_request_env['super_admin_user'] ||= current_user_roles
        .where(name: :administrator, target_id: nil)
        .any?
    end

    # :nodoc:
    # Reek complains about multiple calls to `request.env` and/or not refering to object state...
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
  end

end
