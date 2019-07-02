require 'rails_helper'

RSpec.describe 'Authorization DSL' do
  let(:described_class) do |example|
    Class.new(ApplicationController) do
      include Authegy::Authorization::Helpers
    end
  end

  it 'responds to .access_authorization with a ruleset' do
    expect(described_class).to respond_to :access_authorization
    expect(described_class.access_authorization)
      .to be_kind_of Authegy::Authorization::AccessRuleSet
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

    it 'makes an authorized scope helper available to the class' do
      expect(described_class.new).not_to respond_to :authorized_user_groups
      subject
      expect(described_class.new).to respond_to :authorized_user_groups
    end
    
    context 'with no restrictable class' do
      let(:example_params) { [:authors, of: 'group_post'] }

      it 'does not add any new rules to the access_authorization object' do
        expect { subject }.not_to change { described_class.access_authorization.count }
      end
  
      it 'does not add the "run_resource_authorization" callback' do
        expect do
          subject
        end.not_to change { described_class._process_action_callbacks.count }
        
        expect(described_class._process_action_callbacks)
          .not_to include an_object_having_attributes filter: :run_resource_authorization
      end
    end
  end
end
