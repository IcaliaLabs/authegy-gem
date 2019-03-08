# frozen_string_literal: true

require 'authegy/rails/routes'

module Authegy
  #= Authegy::Engine
  #
  # This is the engine that gets mounted to the rails apps.
  class Engine < ::Rails::Engine
    isolate_namespace Authegy
  end
end
