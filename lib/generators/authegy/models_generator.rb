# frozen_string_literal: true

require 'rails/generators/active_record'
require 'generators/authegy/orm_helpers'

class ModelsGenerator < ActiveRecord::Generators::Base
  namespace 'authegy:models'
  include Authegy::Generators::OrmHelpers
  source_root File.expand_path('templates', __dir__)

  argument :attributes,
           type: :array,
           default: [],
           banner: 'field:type field:type'

  # class_option :primary_key_type, type: :string, desc: 'The type for primary key'

  def copy_authegy_migration
    # if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
    #   migration_template "migration_existing.rb", "#{migration_path}/add_devise_to_#{table_name}.rb", migration_version: migration_version
    # else
      migration_template(
        'models_migration.erb',
        "#{migration_path}/authegy_create_model_tables.rb",
        migration_version: migration_version
      )
    # end
  end

  def generate_app_models
    copy_file 'person_model.rb', 'app/models/person.rb'
    copy_file 'user_model.rb', 'app/models/user.rb'
  end

  def rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  def migration_version
    if rails5_and_up?
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end
end
