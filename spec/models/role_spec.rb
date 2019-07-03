# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authegy::Role, type: :model do
  let(:described_class) do |example|
    ::Role
  end
  
  describe 'persistence' do
    it "uses the 'roles' table" do
      expect(described_class.table_name).to eq 'roles'
    end
  end

  describe 'validations' do
    it 'validates the format of :name' do
      is_expected.not_to allow_value('testname-123').for(:name)
      is_expected.to allow_value('test_name').for(:name)
      is_expected.not_to allow_value('Test').for(:name)
    end
  end
   
end