require 'rails_helper'

RSpec.describe 'Authorization DSL' do
  let(:described_class) do
    Class.new(ApplicationController) do
      include Authegy::Authorization::Helpers
    end
  end

  it 'responds to .authorize_access_for' do
    expect(described_class).to respond_to :authorize_access_for
  end

  describe '.authorize_access_for' do
    let(:example_params) { [:authors, of: 'group_post', to: UserGroup] }

    subject { described_class.authorize_access_for(*example_params) }

    it 'adds a rule to the access_authorization object' do
      expect { subject }.to change { described_class.access_authorization.count }.by 1
    end

    it 'adds the "run_resource_authorization" callback' do
      expect do
        subject
      end.to change { described_class._process_action_callbacks.count }.by 1
      
      expect(described_class._process_action_callbacks)
        .to include an_object_having_attributes filter: :run_resource_authorization
    end
  end
end
