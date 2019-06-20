require 'spec_helper'

RSpec.describe 'authegy:install', type: :generator do
  
  sample_app_ref =  File.expand_path('../fixtures/sample_app', __FILE__) 
  sample_app = File.expand_path('../tmp/sample_app', __FILE__)

  before(:all) do
    FileUtils.cp_r sample_app_ref, sample_app
  end

  after(:all) do
    FileUtils.rm_rf sample_app
  end
  
  it "should do something" do
    expect(true).to eq true
  end
end
