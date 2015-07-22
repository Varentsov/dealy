class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_users, :edit_users, :delete_users]
  before_action :users_in_tree, only: [:add_users, :edit_users]


  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups.default
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @children = @group.subtree.includes(:users)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        employee = Employee.create!(:user_id => current_user.id, :group_id => @group.id)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_users
  end

  def add_users
    if params[:group][:user_ids].present? && !invalid_user_ids?(params[:group][:user_ids])
      Employee.transaction do
        params[:group][:user_ids].each do |user|
          Employee.create!(:user_id => user.to_i, :group_id => @group.id) if user.present?
        end
      end
      redirect_to @group, notice: 'Users add'
    else
      @group.errors.add(:user_ids, 'Cant be blank')
      render :edit_users
    end
  end

  def delete_users
    if params[:group][:user_ids].present? && !invalid_user_ids?(params[:group][:user_ids])
      Employee.where(:group_id => @group.id, :user_id => params[:group][:user_ids]).delete_all
      redirect_to @group, notice: 'Users deleted'
    else
      @group.errors.add(:user_ids, 'Cant be blank')
      render :edit_users
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_workspace
    group = Group.find(params[:workspace])
    session[:workspace] = params[:workspace] if current_user.groups.include? group
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :parent_id)
    end

    def invalid_user_ids?(user_ids)
      if user_ids.first.blank? && user_ids.size == 1
        true
      else
        false
      end
    end

    def users_in_tree
      @users_in_tree = []
      @group.root.subtree.each { |group| group.user_ids.each { |id| @users_in_tree << id }}
    end
end
