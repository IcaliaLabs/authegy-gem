require "rails_helper"

RSpec.describe GroupPostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/group_posts").to route_to("group_posts#index")
    end

    it "routes to #new" do
      expect(:get => "/group_posts/new").to route_to("group_posts#new")
    end

    it "routes to #show" do
      expect(:get => "/group_posts/1").to route_to("group_posts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/group_posts/1/edit").to route_to("group_posts#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/group_posts").to route_to("group_posts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/group_posts/1").to route_to("group_posts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/group_posts/1").to route_to("group_posts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/group_posts/1").to route_to("group_posts#destroy", :id => "1")
    end
  end
end
