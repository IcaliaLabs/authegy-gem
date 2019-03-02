require 'rails_helper'

RSpec.describe "GroupPosts", type: :request do
  describe "GET /group_posts" do
    it "works! (now write some real specs)" do
      get group_posts_path
      expect(response).to have_http_status(200)
    end
  end
end
