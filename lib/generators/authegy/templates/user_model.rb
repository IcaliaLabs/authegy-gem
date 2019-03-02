# frozen_string_literal: true

#= User
#
# Represents a person which is able to sign-in to the application.
# Users are intended for authentification, the actual profile sits in Person.
class User < Authegy::User
  # Authegy::User class already includes associations to :person,
  # and delegations to :person such as :email, :has_role?, etc.

  # The `Authegy::User` class also includes the :database_authenticatable and
  # :validatable modules, with some modifications so it uses the Person.email
  # field for authentication instead.

  # You may include additional devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :recoverable, :rememberable
end
