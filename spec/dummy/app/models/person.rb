# frozen_string_literal: true

# Person holds the "Profile" for a given User, but we can also have just Person
# profiles without a user, as is the case for "Board Members"
class Person < Authegy::Person
  # Authegy::Person already includes validations for the email field, and
  # associations for :user, :role_assignments, :assigned_roles, and methods
  # for authorization, such as :assign_role, :has_role?, etc.
end
