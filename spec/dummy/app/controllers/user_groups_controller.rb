class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[show edit update destroy]

  # NOTE: All Authegy authorization processes are bypassed for requests from:
  # - People with an unscoped 'Administrator' role (i.e. without a resource)
  # - OAuth2 Apps with a trust level of 0 (the most trustworthy), authenticated
  #   via "Client Credentials"

  # The first guard on our authorization process, acts upon the @groups and
  # @group variables, hiding records that fail to match the authorization
  # criteria from the results:
  authorize_access_for :owners, :members, :moderators,
                       of: 'user_group',
                       to: UserGroup

  # GET /user_groups
  def index
    @groups = authorized_user_groups.all
  end

  # GET /user_groups/1
  def show
  end

  # GET /user_groups/new
  def new
    @group = UserGroup.new
  end

  # GET /user_groups/1/edit
  def edit
  end

  # POST /user_groups
  def create
    @group = UserGroup.new(user_group_params)

    if @group.save
      redirect_to @group, notice: 'User group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user_groups/1
  def update
    if @group.update(user_group_params)
      redirect_to @group, notice: 'User group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_groups/1
  def destroy
    @group.destroy
    redirect_to user_groups_url, notice: 'User group was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_group
    @group = authorized_user_groups.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_group_params
    params.require(:user_group).permit(:name, :description)
  end
end
