require 'rails_helper'

RSpec.describe 'authegy:install', type: :generator do
  around do |example|
    # Setup
    example_app_source_path = File.expand_path('../../fixtures/sample_app', __FILE__)
    example_app_path = File.expand_path('../tmp/', __FILE__)
    original_path = Dir.pwd

    FileUtils.cp_r example_app_source_path, example_app_path
    Dir.chdir example_app_path
    
    run_generator 'authegy:install'

    example.run
    
    # Teardown
    Dir.chdir original_path
    FileUtils.rm_rf example_app_path
  end

  context 'runs the devise & authegy installation' do 
  
    it 'should exist user model file' do
      expect(File).to exist 'app/models/user.rb'
    end

    it 'should exist person model file' do
      expect(File).to exist 'app/models/person.rb'
    end

    it 'should exist role model file' do
      expect(File).to exist 'app/models/role.rb'
    end

    it 'should exist role assignment model file' do
      expect(File).to exist 'app/models/role_assignment.rb'
    end

    it 'should exist migration file' do
      expect(File).to exist "db/migrate/#{migration_file}"
    end

    it 'should have the expected content in user model file' do
      templates_path = "../../../lib/generators/authegy/templates/"
      expect(FileUtils.compare_file(File.expand_path("app/models/user.rb"), File.expand_path("#{templates_path}user_model.rb"))).to be_truthy
    end

    it 'should have the expected content in person model file' do
      templates_path = "../../../lib/generators/authegy/templates/"
      expect(FileUtils.compare_file(File.expand_path("app/models/person.rb"), File.expand_path("#{templates_path}person_model.rb"))).to be_truthy
    end

    it 'should have the expected content in role model file' do
      templates_path = "../../../lib/generators/authegy/templates/"
      expect(FileUtils.compare_file(File.expand_path("app/models/role.rb"), File.expand_path("#{templates_path}role_model.rb"))).to be_truthy
    end

    it 'should have the expected content in role_assignment model file' do
      templates_path = "../../../lib/generators/authegy/templates/"
      expect(FileUtils.compare_file(File.expand_path("app/models/role_assignment.rb"), File.expand_path("#{templates_path}role_assignment_model.rb"))).to be_truthy
    end

    it 'should have the expected content in migration file' do
      templates_path = "../../../lib/generators/authegy/templates/"
      expect(File.read("db/migrate/#{migration_file}")).to eq render_erb_file("#{templates_path}models_migration.erb")
    end

    it 'should modify the existing devise file' do
      expect(File.read("config/initializers/devise.rb")).to include('config.sign_out_via = %i[get delete]')
    end

    it 'should modify the routes config file' do
      expect(File.read("config/routes.rb")).to include("authegy_routes")
    end
  end
end
    