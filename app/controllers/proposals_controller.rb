class ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :edit, :update, :destroy, :accept]

  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = Proposal.where(:receiver_id => current_employee.id)
  end

  def outbox
    @proposals = Proposal.where(:supplier_id => current_employee.id)
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
  end

  # GET /proposals/1/edit
  def edit
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

  # PATCH/PUT /proposals/1
  # PATCH/PUT /proposals/1.json
  def update
    respond_to do |format|
      if @proposal.update(proposal_params)
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { render :show, status: :ok, location: @proposal }
      else
        format.html { render :edit }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    EmployeeTask.unscoped.where(:employee_id => @proposal.supplier_id, :task_id => @proposal.task_id).take.update_attribute(:state, :active)
    @proposal.destroy
    respond_to do |format|
      format.html { redirect_to proposals_url, notice: 'Proposal was successfully destroyed.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      params.require(:proposal).permit(:task_id, :supplier_id, :receiver_id)
    end
end
