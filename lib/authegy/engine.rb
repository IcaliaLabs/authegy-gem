# frozen_string_literal: true

require 'authegy/rails/routes'

module Authegy
  class Engine < ::Rails::Engine
    isolate_namespace Authegy
  end
end
