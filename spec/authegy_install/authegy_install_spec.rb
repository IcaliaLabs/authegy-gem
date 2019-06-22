require_relative '../spec_helper'
require_relative 'authegy_install_spec_helper'

RSpec.describe 'authegy:install', type: :generator do

  around do |example|
    # Setup
    example_app_source_path = File.expand_path('../fixtures/sample_app', __FILE__)
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
      expect(File).to exist 'app/models/user.rb'
      expect(File).to exist 'app/models/role_assignment.rb'
      expect(File).to exist "db/migrate/#{migration_file}"
    end
  end
end
