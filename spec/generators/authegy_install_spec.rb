require 'rails_helper'

RSpec.describe 'authegy:install', type: :generator do
  before(:context) do
    # Setup
    setup_example_app_context 'example_blank_app'

    run_generator 'authegy:install'
  end

  after(:context) do
    # Teardown
    teardown_example_app_context 'example_blank_app'
  end

  it 'generates a user model that inherits from Authegy::User' do
    expect(File).to exist 'app/models/user.rb'
    contents = File.read 'app/models/user.rb'
    expect(contents).to include 'class User < Authegy::User'
  end

  it 'generates a person model that inherits from Authegy::Person' do
    expect(File).to exist 'app/models/person.rb'
    contents = File.read 'app/models/person.rb'
    expect(contents).to include 'class Person < Authegy::Person'
  end

  it 'generates a role model file that inherits from Authegy::Role' do
    expect(File).to exist 'app/models/role.rb'
    contents = File.read 'app/models/role.rb'
    expect(contents).to include 'class Role < Authegy::Role'
  end

  it 'generates a role assignment model file that inherits from Authegy::RoleAssignment' do
    expect(File).to exist 'app/models/role_assignment.rb'
    contents = File.read 'app/models/role_assignment.rb'
    expect(contents).to include 'class RoleAssignment < Authegy::RoleAssignment'
  end

  it 'generates the authegy models migration file' do
    is_expected.to have_migration 'create_authegy_model_tables'
  end

  it 'should have the expected content in migration file' do
    contents = migration_contents('create_authegy_model_tables')

    expect(contents).to include 'create_table :people do |t|'
    expect(contents).to include 'create_table :users do |t|'
    expect(contents).to include 'create_table :roles do |t|'
    expect(contents).to include 'create_table :role_assignments do |t|'
  end

  it 'configures Devise to sign out via get and delete' do
    devise_initializer_contents = File.read 'config/initializers/devise.rb'
    expect(devise_initializer_contents)
      .to include 'config.sign_out_via = %i[get delete]'
  end

  it 'adds the authegy routes to the app' do
    routes_file_contents = File.read 'config/routes.rb'
    expect(routes_file_contents).to include 'authegy_routes'
  end
end
    