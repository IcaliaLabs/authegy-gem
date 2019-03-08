# frozen_string_literal: true

require 'active_support/dependencies'
require 'devise'
require 'authegy/engine'

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
end
