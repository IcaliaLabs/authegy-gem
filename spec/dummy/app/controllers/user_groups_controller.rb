class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[show edit update destroy]

  # authorize_action! :edit, :update, :delete,
  #                   to: %i[owner administrator],
  #                   of: :user_group

  # allow_access! to: %i[member], of: :user_group


  # GET /user_groups
  def index
    @user_groups = UserGroup.all
  end

  # GET /user_groups/1
  def show
  end

  # GET /user_groups/new
  def new
    @user_group = UserGroup.new
  end

  # GET /user_groups/1/edit
  def edit
  end

  # POST /user_groups
  def create
    @user_group = UserGroup.new(user_group_params)

    if @user_group.save
      redirect_to @user_group, notice: 'User group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user_groups/1
  def update
    if @user_group.update(user_group_params)
      redirect_to @user_group, notice: 'User group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_groups/1
  def destroy
    @user_group.destroy
    redirect_to user_groups_url, notice: 'User group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_group
      @user_group = UserGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_group_params
      params.require(:user_group).permit(:name, :description)
    end
end
