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
   
end