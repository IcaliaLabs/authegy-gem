# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authegy::User, type: :model do

  let(:described_class) do |example|
    ::User
  end

  describe 'persistence' do
    it "uses the 'users' table" do
      expect(described_class.table_name).to eq 'users'
    end
  end

end