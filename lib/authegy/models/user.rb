# frozen_string_literal: true

require 'devise/models/validatable_with_person_email'
require 'devise/models/database_authenticatable_with_person_email'

module Authegy
  #= User
  #
  # Represents a person which is able to sign-in to the application.
  # Users are intended for authentification, the actual profile sits in Person.
  class User < ApplicationRecord
    self.table_name = :users
    self.abstract_class = true

    devise :database_authenticatable_with_person_email,
           :validatable_with_person_email

    belongs_to :person,
               class_name: '::Person',
               inverse_of: :user,
               foreign_key: :id

    delegate :email, :email=, :name, to: :person, allow_nil: true

    delegate :assigned_roles, :assign_role, :has_role?, :has_any_role?,
             :remove_role, :role_assignments, to: :person
  end
end
