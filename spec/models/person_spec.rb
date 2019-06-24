# frozen_string_literal: true
require_relative '../spec_helper'

RSpec.describe 'Person', type: :model do
  let(:described_class) do
    ApplicationRecord = Class.new(ActiveRecord::Base)
    Person = Class.new(Authegy::Person)
    Person
  end

  it 'has a user' do
    expect(subject).to respond_to :user
  end
end