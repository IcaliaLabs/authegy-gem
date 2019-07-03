# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'of an Authegy::Authorizable model' do

  let(:described_class) do |example|
    ::Person
  end

  let(:example_role) { ::Role.create! name: 'example_role' }
  let(:example_person) { ::Person.create! email: 'example@person.com' }
  let(:example_owner) { ::Person.create! email: 'owner@person.com' }

  describe "Authegy::Authorizable associations" do
    it 'has many role assignments' do
      is_expected.to have_many(:role_assignments)
                    .class_name('::RoleAssignment')
                    .inverse_of(:actor)
                    .with_foreign_key :actor_id
    end

    it 'has many assigned roles through role assignments' do
      is_expected.to have_many(:assigned_roles)
                     .through(:role_assignments)
                     .source(:role)
    end

    it 'assigned roles are unique' do
      # Let's make sure we have more than one role assigned to the user:
      [
        UserGroup.create!(name: 'example-group', owner: example_owner),
        UserGroup.create!(name: 'another-example-group', owner: example_owner)
      ].each do |resource|
        ::RoleAssignment.create! actor: example_person,
                                 role: example_role,
                                 resource: resource
      end

      expect(example_person.role_assignments.count).to eq 2
      expect(example_person.assigned_roles).to include example_role
      expect(example_person.assigned_roles.count).to eq 1
    end

    describe '.assign_role ' do
      
      context 'without a context resource' do

        it 'assings a role to a person' do
          expect(example_person.assign_role(example_role)).to eq ::RoleAssignment.first
        end

      end

      context 'with a context resource' do

        resource = 'admin'
        it 'assings a role to a person' do
          expect(example_person.assign_role(example_role, resource)).to eq ::RoleAssignment.first
        end

      end


    end
  end
end