# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authegy::Person, type: :model do

  it "should be exist a table called 'people'" do
    expect(ActiveRecord::Base.connection.table_exists? 'people').to be_truthy
  end

  it { should have_one(:user).inverse_of(:person) }

  it { is_expected.to validate_uniqueness_of(:email) }

  


end