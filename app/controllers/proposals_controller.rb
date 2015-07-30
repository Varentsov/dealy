class ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :destroy, :accept]
  before_action :allowed_user, except: [:index, :outbox, :new]

  # GET /proposals
  # GET /proposals.json
  def index
    @employees = Employee.where(:user_id => current_user.id).includes(:inbox_proposals, :group)
  end

  def outbox
    @employees = Employee.where(:user_id => current_user.id).includes(:outbox_proposals, :group)
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(proposal_params)

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render :show, status: :created, location: @proposal }
      else
        format.html { render :new }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    EmployeeTask.where(:employee_id => @proposal.supplier_id, :task_id => @proposal.task_id).take.update_attribute(:state, :active)
    @proposal.destroy
    respond_to do |format|
      format.html { redirect_to_back_or_default notice: 'Proposal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def accept
    @task = @proposal.task
    @task.delegate(@proposal.supplier_id, @proposal.receiver_id)
    @proposal.destroy
    redirect_to tasks_path, notice: "Заявка принята, теперь задача есть в вашем списке"
  end

  private

    def allowed_user
      if current_user.employee_ids.include?(@proposal.supplier_id) or current_user.employee_ids.include?(@proposal.receiver_id)
      else
        redirect_to root_path, notice: "У вас нет прав для просмотра"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      params.require(:proposal).permit(:task_id, :supplier_id, :receiver_id)
    end
end
