# frozen_string_literal: true

module Authegy
  # A `RoleAssignment` associates a `Person` to an optional "resource", and
  # assigns a particular roleholds the "Profile" for a given User, but we can
  # also have just Person profiles without a user, as is the case for
  # "Board Members"
  class RoleAssignment < ActiveRecord::Base
    self.table_name = :role_assignments

    belongs_to :actor, class_name: 'Person', foreign_key: :actor_id
    belongs_to :role,  class_name: 'Authegy::Role'
    belongs_to :resource, optional: true, polymorphic: true
  end
end
