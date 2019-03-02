# frozen_string_literal: true

require 'rails/generators/base'

class InstallGenerator < Rails::Generators::Base
  namespace 'authegy:install'
  source_root File.expand_path('templates', __dir__)


  def generate_customized_devise_install
    generate 'devise:install'

    gsub_file 'config/initializers/devise.rb',
              'config.sign_out_via = :delete',
              'config.sign_out_via = %i[get delete]'
  end

  def generate_authegy_install
    generate 'authegy:models People'
  end

  def add_devise_routes
    route <<~STRING
      devise_for :users,
                 path: '/',
                 path_names: { sign_in: 'sign-in', sign_out: 'sign-out' }
    STRING
  end
end
