require 'active_support/dependencies'
require 'devise'
require 'authegy/engine'

module Authegy
  autoload :Authorizable,   'authegy/authorizable'

  autoload :Person,         'authegy/models/person'
  autoload :RoleAssignment, 'authegy/models/role_assignment'
  autoload :Role,           'authegy/models/role'
  autoload :User,           'authegy/models/user'

  autoload :ControllerHelpers, 'authegy/controller_helpers'

  def self.extract_resource_attributes(resource_type_or_instance)
    return { resource_type: resource_type_or_instance } \
      if resource_type_or_instance.is_a? String

    return { resource_type: resource_type_or_instance.name } \
      if resource_type_or_instance.is_a? Class

    return {
      resource_type: resource_type_or_instance.class.name,
      resource_id: resource_type_or_instance.id
    } if resource_type_or_instance.respond_to? :id
  end
end
