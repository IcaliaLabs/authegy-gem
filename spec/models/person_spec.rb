# frozen_string_literal: true

require 'rails_helper'
require_relative 'authegy_authorizable_examples'

RSpec.describe Authegy::Person, type: :model do
  let(:described_class) do |example|
    ::Person
  end

  include_examples 'of an Authegy::Authorizable model'

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

  describe '.having_role scope' do
    let!(:example_role) { ::Role.create! name: 'example_role' }
    let!(:example_person) { described_class.create! email: 'example@email.com' }

    context 'without a context resource' do
      subject { described_class.having_role(example_role.name) }

      it 'includes people having the given role' do
        ::RoleAssignment.create! actor: example_person, role: example_role

        is_expected.to include example_person
      end

      it 'excludes people not having the given role' do
        is_expected.not_to include example_person
      end
    end

    context 'with a context resource' do
      let(:example_resource_owner) { ::Person.create! email: 'owner@example.com' }
      
      let! :example_resource do
        UserGroup.create! name: 'example-group', owner: example_resource_owner
      end

      let :another_example_resource do
        UserGroup.create! name: 'another-example-group', owner: example_resource_owner
      end

      subject { described_class.having_role(example_role.name, example_resource) }

      it 'includes people having the given role for the given resource' do
        ::RoleAssignment.create! actor: example_person,
                                 role: example_role,
                                 resource: example_resource

        is_expected.to include example_person
      end

      it 'excludes people not having the given role for the given resource' do
        ::RoleAssignment.create! actor: example_person,
                                 role: example_role,
                                 resource: another_example_resource

        is_expected.not_to include example_person
      end
    end
  end
end