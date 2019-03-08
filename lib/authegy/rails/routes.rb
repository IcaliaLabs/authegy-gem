# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def authegy_routes(options = {})
        # Remove the keys that would interfere with the authegy way:
        options.extract! :class_name, # We'll only use 'User'
                         :path,       # All devise paths available from root
                         :singular    # No 'resource name' required

        default_path_names = { sign_in: 'sign-in', sign_out: 'sign-out' }
        options.reverse_merge! path: '/', path_names: default_path_names

        devise_for :users, options
      end
    end
  end
end
