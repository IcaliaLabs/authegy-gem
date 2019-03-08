# frozen_string_literal: true

#= RoleAssignment
#
# Associates a Person with a Role, and optionally to a Resource
class RoleAssignment < Authegy::RoleAssignment
  # Authegy::RoleAssignment already defines associations to :actor, :role and
  # :resource
end
