require 'active_support/dependencies'
require 'devise'
require 'authegy/engine'

module Authegy
  autoload :Authorizable,   'authegy/authorizable'
  autoload :Role,           'authegy/models/role'
  autoload :RoleAssignment, 'authegy/models/role_assignment'

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

module Devise
  module Models
    autoload :DatabaseAuthenticatableWithPersonEmail,
             'devise/models/database_authenticatable_with_person_email'
    autoload :ValidatableWithPersonEmail,
            'devise/models/validatable_with_person_email'
  end
end
