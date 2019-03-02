# frozen_string_literal: true

#= User
#
# Represents a person which is able to sign-in to the application.
# Users are intended for authentification, the actual profile sits in Person.
class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable_with_person_email, :registerable,
         :recoverable, :rememberable, :validatable_with_person_email

  belongs_to :person, inverse_of: :user, foreign_key: :id
  delegate :email, :email=, :name, to: :person, allow_nil: true

  delegate :assigned_roles, :assign_role, :has_role?, :has_any_role?,
           :remove_role, :role_assignments, to: :person
end
