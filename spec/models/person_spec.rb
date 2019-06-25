# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authegy::Person, type: :model do
  it { should have_one(:user).inverse_of(:person) }
  it { is_expected.to validate_uniqueness_of(:email) }

  # it 'has a user' do
  #   expect(subject).to respond_to :user
  # end


end