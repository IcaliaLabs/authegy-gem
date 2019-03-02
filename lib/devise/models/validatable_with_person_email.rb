module Devise
  module Models
    #= ValidatableWithPersonEmail
    #
    # A re-implementation of Devise::Models::Validatable, but instead of
    # expecting the `email` field to be in the authenticatable model, is located
    # instead in the `Person` associated model
    module ValidatableWithPersonEmail
      extend ActiveSupport::Concern

      included do
        validates_presence_of :password, if: :password_required?
        validates_confirmation_of :password, if: :password_required?

        validates_length_of :password,
                            within: password_length,
                            allow_blank: true

        validate :person_email_must_be_present
      end

      module ClassMethods
        Devise::Models.config self, :email_regexp, :password_length
      end

      protected

      # Checks whether a password is needed or not. For validations only.
      # Passwords are always required if it's a new record, or if the password
      # or confirmation are being set somewhere.
      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end

      def person_email_must_be_present
        return if person&.email.present?
        errors.add :base, 'Person email must be present'
      end
    end
  end
end
