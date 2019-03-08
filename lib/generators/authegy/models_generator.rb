# frozen_string_literal: true

require 'rails/generators/active_record'
require 'generators/authegy/orm_helpers'

#= ModelsGenerator
#
# Generates the Authegy models & migrations
class ModelsGenerator < ActiveRecord::Generators::Base
  namespace 'authegy:models'
  include Authegy::Generators::OrmHelpers
  source_root File.expand_path('templates', __dir__)

  argument :attributes,
           type: :array,
           default: [],
           banner: 'field:type field:type'

  def copy_authegy_migration
    # if (behavior == :invoke && model_exists?) ||
    #    (behavior == :revoke && migration_exists?(table_name))
    #   migration_template "migration_existing.rb",
    #                      "#{migration_path}/add_devise_to_#{table_name}.rb",
    #                      migration_version: migration_version
    # else
    migration_template(
      'models_migration.erb',
      "#{migration_path}/create_authegy_model_tables.rb",
      migration_version: migration_version
    )
    # end
  end

  def generate_app_models
    copy_file 'person_model.rb',          'app/models/person.rb'
    copy_file 'role_model.rb',            'app/models/role.rb'
    copy_file 'user_model.rb',            'app/models/user.rb'
    copy_file 'role_assignment_model.rb', 'app/models/role_assignment.rb'
  end

  def self.rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  delegate :rails_5_and_up?, to: :class

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
  end
end
