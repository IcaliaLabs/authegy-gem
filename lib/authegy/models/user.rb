# frozen_string_literal: true

require 'devise/models/validatable_with_person_email'
require 'devise/models/database_authenticatable_with_person_email'

module Authegy
  #= User
  #
  # Represents a person which is able to sign-in to the application.
  # Users are intended for authentification, the actual profile sits in Person.
  class User < ApplicationRecord
    self.abstract_class = true
    
    self.table_name = :Users

    devise :database_authenticatable_with_person_email,
           :validatable_with_person_email

    belongs_to :person,
               class_name: '::Person',
               inverse_of: :user,
               foreign_key: :id

    delegate :email, :name, to: :person, allow_nil: true

    def email=(value)
      if person.present?
        person.email = value
      else
        build_person(email: value).email
      end
    end

    delegate :assigned_roles, :assign_role, :has_role?, :has_any_role?,
             :remove_role, :role_assignments, to: :person
  end
end
