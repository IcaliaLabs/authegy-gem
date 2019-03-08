# frozen_string_literal: true

module Devise
  module Models
    #= Devise::Models::DatabaseAuthenticatableWithPersonEmail
    #
    # Overrides Devise::Models::DatabaseAuthenticatable, so but instead of
    # expecting the `email` field to be in the authenticatable model, is located
    # instead in the associated `Person` model
    module DatabaseAuthenticatableWithPersonEmail
      extend ActiveSupport::Concern

      included do
        # Include the original module:
        devise :database_authenticatable
      end

      #= Devise::Models::DatabaseAuthenticatableWithPersonEmail::ClassMethods
      #
      # Methods that override the Devise::Models::Authenticatable class methods
      module ClassMethods
        Devise::Models.config self

        # Override of
        # Devise::Models::Authenticatable.find_first_by_auth_conditions:
        def find_first_by_auth_conditions(tainted_conditions, opts = {})
          filter = devise_parameter_filter.filter(tainted_conditions).merge opts
          person_filter = filter.extract! :email
          matching_person_scope = Person.where person_filter
          User.where(filter).joins(:person).merge(matching_person_scope).first
        end
      end
    end
  end
end
