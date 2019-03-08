# frozen_string_literal: true

require 'active_support/dependencies'

#= Authegy
#
# Authegy is an opinionated library that states a simple-yet-comprehensive way
# of operating Users, Roles, etc in a rails app.
module Authegy
  autoload :Authorizable,   'authegy/authorizable'

  autoload :Person,         'authegy/models/person'
  autoload :RoleAssignment, 'authegy/models/role_assignment'
  autoload :Role,           'authegy/models/role'
  autoload :User,           'authegy/models/user'

  module Authorization
    autoload :Rule,             'authegy/authorization/rule'
    autoload :AccessRuleByRole, 'authegy/authorization/access_rule_by_role'
    autoload :AccessRuleByAssociation,
             'authegy/authorization/access_rule_by_association'

    autoload :RuleSet,       'authegy/authorization/rule_set'
    autoload :AccessRuleSet, 'authegy/authorization/access_rule_set'
    autoload :ActionRuleSet, 'authegy/authorization/action_rule_set'

    autoload :Helpers,       'authegy/authorization/helpers'
    autoload :AccessHelpers, 'authegy/authorization/access_helpers'
    autoload :ActionHelpers, 'authegy/authorization/action_helpers'
  end

  def self.extract_resource_attributes(resource_type_or_instance)
    if resource_type_or_instance.is_a?(String)
      { resource_type: resource_type_or_instance }
    elsif resource_type_or_instance.is_a?(Class)
      { resource_type: resource_type_or_instance.name }
    elsif resource_type_or_instance.respond_to?(:id)
      {
        resource_type: resource_type_or_instance.class.name,
        resource_id: resource_type_or_instance.id
      }
    end
  end

  require 'authegy/railtie' if defined?(Rails)
end
