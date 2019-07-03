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
end