require 'spec_helper'

RSpec.describe 'authegy:install', type: :generator do
  def run_generator(generator_name)
    system "rails g #{generator_name}"
  end

  around do |example|
    # Setup
    example_app_source_path = File.expand_path('../fixtures/sample_app', __FILE__)
    example_app_path = File.expand_path('../tmp/sample_app', __FILE__)
    original_path = Dir.pwd

    FileUtils.cp_r example_app_source_path, example_app_path
    Dir.chdir example_app_path
    
    example.run
    
    # Teardown
    Dir.chdir original_path
    FileUtils.rm_rf example_app_path
  end
  
  it 'runs the devise & authegy installation' do
    run_generator 'authegy:install'
    expect(File).to exist 'app/models/user.rb'
    expect(File).to exist 'app/models/person.rb'
  end
end
