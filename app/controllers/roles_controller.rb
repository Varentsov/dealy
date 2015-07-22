class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :allowed_groups, only: [:new, :create, :index]

  # GET /roles
  # GET /roles.json
  def index
    @group = Group.find(params[:group_id])
    @roles = @group.roles
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @group = Group.find(params[:group_id])
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    @group = Group.find(params[:group_id])
  end

  # POST /roles
  # POST /roles.json
  def create
    @group = Group.find(params[:group_id])
    @role = @group.roles.create(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to group_role_path(@role.group_id, @role), notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to group_role_path(@role.group_id, @role), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to group_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :group_id)
    end

    def allowed_groups
      @group = Group.find(params[:group_id])
      if @group.user?
        redirect_to_back_or_default notice: 'Roles can only applied to default groups'
      end
    end
end
