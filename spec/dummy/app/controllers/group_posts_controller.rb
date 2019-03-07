class GroupPostsController < ApplicationController
  before_action :set_group_post, only: %i[show edit update destroy]

  # NOTE: All Authegy authorization processes are bypassed for requests from:
  # - People with an unscoped 'Administrator' role (i.e. without a resource)
  # - OAuth2 Apps with a trust level of 0 (the most trustworthy), authenticated
  #   via "Client Credentials"

  # The first guard on our authorization process, acts upon the @user_groups and
  # @user_group variables, hiding records that fail to match the authorization
  # criteria from the results:
  authorize_access_for :authors, of: 'group_post', to: GroupPost

  authorize_access_for :owners, :moderators, :members,
                       of: 'group_post.group',
                       to: GroupPost

  # Would this be possible??
  # authorize_access_to GroupPost, for: :moderators, :owners, :members, of: '.group'

  # GET /group_posts
  def index
    @posts = authorized_group_posts.where(group_id: params[:group_id])
  end

  # GET /group_posts/1
  def show
  end

  # GET /group_posts/new
  def new
    @post = GroupPost.new
  end

  # GET /group_posts/1/edit
  def edit
  end

  # POST /group_posts
  def create
    @post = GroupPost.new(group_post_params)

    if @post.save
      redirect_to @post, notice: 'Group post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /group_posts/1
  def update
    if @post.update(group_post_params)
      redirect_to @post, notice: 'Group post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /group_posts/1
  def destroy
    @post.destroy
    redirect_to group_posts_url, notice: 'Group post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group_post
    @post = authorized_group_posts.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_post_params
    params.require(:group_post).permit(:group_id, :author_id, :title, :body)
  end
end
