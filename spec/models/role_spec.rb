# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authegy::Role, type: :model do
  let(:described_class) do |example|
    ::Role
  end
  let(:example_person) { ::Person.create! email: 'example@person.com' }
  let(:example_role) { ::Role.create! name: 'example_role' }
  
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

  describe 'associations' do
    it 'has many "assignments", inverse of "role"' do
      is_expected.to have_many(:assignments).inverse_of(:role)
    end

    it 'has many actors' do
        is_expected.to have_many(:actors)
                                .through(:assignments)
                                .source(:actor)
    end

    it 'actors are unique' do
        [example_person, example_person].each do |person|
          ::RoleAssignment.create! actor: person,
                                   role: example_role
        end

        expect(example_role.actors.count).to eq 1
      end
  end
   
end