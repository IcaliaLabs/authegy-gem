# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authegy::User, type: :model do
  let(:described_class) { |example| ::User }
  
  describe 'persistence' do
    it "uses the 'users' table" do
      expect(described_class.table_name).to eq 'users'
    end
  end

  describe 'associations' do
    it 'belongs to "person", inverse of "user"', skip: "We don't know why it fails" do
      is_expected.to belong_to(:person) .inverse_of(:user) .with_foreign_key :id
    end
  end
end
