# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authegy::Person, type: :model do
  let(:described_class) do |example|
    Class.new(Authegy::Person) do
      def self.model_name
        ActiveModel::Name.new self, nil, 'example_person'
      end
    end
  end

  let(:example_role_class) do
    Class.new(Authegy::Role) do
      def self.model_name
        ActiveModel::Name.new self, nil, 'example_role'
      end
    end
  end

  let(:example_role_assignment_class) do
    Class.new(Authegy::RoleAssignment) do
      def self.model_name
        ActiveModel::Name.new self, nil, 'example_role_assignment'
      end
    end
  end

  # include_examples 'of an Authegy::Authorizable model'

  describe 'validations' do
    it 'validates the uniqueness of :email' do
      is_expected.to validate_uniqueness_of(:email)
    end
  
    it 'validates the format of :email' do
      is_expected.not_to allow_value('no-email.com').for(:email)
    end
  
    it 'allows a blank :email' do
      is_expected.to allow_value(nil).for(:email)
    end
  end

  describe 'persistence' do
    it "uses the 'people' table" do
      expect(described_class.table_name).to eq 'people'
    end
  end

  describe 'associations' do
    it 'has one "user", inverse of "person"' do 
      is_expected.to have_one(:user).inverse_of(:person)
    end
  end
end