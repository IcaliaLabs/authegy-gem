# frozen_string_literal: true

# Person holds the "Profile" for a given User, but we can also have just Person
# profiles without a user, as is the case for "Board Members"
class Person < ApplicationRecord
  include Authegy::Authorizable

  # Validations from 'validatable':
  validates_uniqueness_of :email,
                          allow_blank: true,
                          if: :will_save_change_to_email?

  validates_format_of :email,
                      with: Devise.email_regexp,
                      allow_blank: true,
                      if: :will_save_change_to_email?

  has_one :user, inverse_of: :person, foreign_key: :id
end
