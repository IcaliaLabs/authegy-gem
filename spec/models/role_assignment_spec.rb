require 'rails_helper'

RSpec.describe Authegy::RoleAssignment, type: :model do
  let(:described_class) do |example|
    ::RoleAssignment
  end

  describe 'persistence' do
    it "uses the 'role_assignments' table" do
      expect(described_class.table_name).to eq 'role_assignments'
    end
  end

  describe 'associations' do
    it 'belongs to "actor"' do
      is_expected.to belong_to(:actor).with_foreign_key :actor_id
    end

    it 'belongs to "role"' do
        is_expected.to belong_to(:role)
    end

    it 'belongs to "resource"' do
        is_expected.to belong_to(:resource).optional
    end
  end
end