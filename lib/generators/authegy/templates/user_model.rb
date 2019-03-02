# frozen_string_literal: true

#= User
#
# Represents a person which is able to sign-in to the application.
# Users are intended for authentification, the actual profile sits in Person.
class User < Authegy::User
  # Authegy::User class already includes associations to :person,
  # and delegations to :person such as :email, :has_role?, etc.

  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable_with_person_email, :registerable,
         :recoverable, :rememberable, :validatable_with_person_email
end
