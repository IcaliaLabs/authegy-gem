# frozen_string_literal: true

require 'rails_helper'
require_relative 'authegy_authorizable_examples'

RSpec.describe Authegy::User, type: :model do
  let(:described_class) { |example| ::User }

  include_examples 'of an Authegy::Authorizable model methods'
  
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

  describe '.email=' do

    context 'when person is not present' do
      let(:example_user) { described_class.new(email: "example@email.com", password: "123456789") }
      it 'assigns the email value to the person' do
        expect(example_user.person.id.blank?).to be_truthy
        expect(example_user.email=('another@email.com')).to eq example_user.person.email
      end
    end

    
  end
end
