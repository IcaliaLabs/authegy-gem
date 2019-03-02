class GroupPostsController < ApplicationController
  before_action :set_group_post, only: [:show, :edit, :update, :destroy]

  # GET /group_posts
  def index
    @group_posts = GroupPost.all
  end

  # GET /group_posts/1
  def show
  end

  # GET /group_posts/new
  def new
    @group_post = GroupPost.new
  end

  # GET /group_posts/1/edit
  def edit
  end

  # POST /group_posts
  def create
    @group_post = GroupPost.new(group_post_params)

    if @group_post.save
      redirect_to @group_post, notice: 'Group post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /group_posts/1
  def update
    if @group_post.update(group_post_params)
      redirect_to @group_post, notice: 'Group post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /group_posts/1
  def destroy
    @group_post.destroy
    redirect_to group_posts_url, notice: 'Group post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_post
      @group_post = GroupPost.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_post_params
      params.require(:group_post).permit(:group_id, :author_id, :title, :body)
    end
end
