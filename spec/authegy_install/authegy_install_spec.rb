require_relative '../spec_helper'
require_relative 'authegy_install_spec_helper'

RSpec.describe 'authegy:install', type: :generator do

  around do |example|
    # Setup
    example_app_source_path = File.expand_path('../../fixtures/sample_app', __FILE__)
    example_app_path = File.expand_path('../tmp/', __FILE__)
    original_path = Dir.pwd

    FileUtils.cp_r example_app_source_path, example_app_path
    Dir.chdir example_app_path
    
    example.run
    
    # Teardown
    Dir.chdir original_path
    FileUtils.rm_rf example_app_path
  end

  context 'runs the devise & authegy installation' do 
  
    it 'should exist all authegy files' do
      run_generator 'authegy:install'
      expect(File).to exist 'app/models/user.rb'
      expect(File).to exist 'app/models/person.rb'
      expect(File).to exist 'app/models/role.rb'
      expect(File).to exist 'app/models/role_assignment.rb'
      expect(File).to exist "db/migrate/#{migration_file}"
    end

    it 'all generated files should have the expected content' do
      templates_path = "../../../lib/generators/authegy/templates/"
      run_generator 'authegy:install'
      expect(FileUtils.compare_file(File.expand_path("app/models/user.rb"), File.expand_path("#{templates_path}user_model.rb"))).to be_truthy
      expect(FileUtils.compare_file(File.expand_path("app/models/person.rb"), File.expand_path("#{templates_path}person_model.rb"))).to be_truthy
      expect(FileUtils.compare_file(File.expand_path("app/models/role.rb"), File.expand_path("#{templates_path}role_model.rb"))).to be_truthy
      expect(FileUtils.compare_file(File.expand_path("app/models/role_assignment.rb"), File.expand_path("#{templates_path}role_assignment_model.rb"))).to be_truthy
      expect(File.read("db/migrate/#{migration_file}")).to eq render_erb_file("#{templates_path}models_migration.erb")
    end

    it 'should modified the existing files' do
      run_generator 'authegy:install'
      expect(File.read("config/initializers/devise.rb")).to include('config.sign_out_via = %i[get delete]')
      expect(File.read("config/routes.rb")).to include("authegy_routes")
    end
  end
end
    