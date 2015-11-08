class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :delegate, :restore, :remove_access, :confirm_completion, :refuse_completion]
  before_action :allowed_user, except: [:new, :create, :index, :all_tasks, :clear_sort, :edit_sort, :in_control]

  # GET /tasks
  # GET /tasks.json
  def index
    @today_tasks_sorted = current_employee.active_tasks.where.not(:sort_value => nil, :finished => true).order(:sort_value => :asc)
    @today_tasks_over_deadline = current_employee.active_tasks.where("finished = ? AND deadline < ?", false, Date.today.beginning_of_day).order(:fire => :desc, :deadline => :asc) - @today_tasks_sorted
    @today_tasks_normal = current_employee.active_tasks.where("finished = ? AND (deadline BETWEEN ? AND ? OR planning_state = ?)", false, Date.today.beginning_of_day, Date.today.end_of_day, Task.planning_states[:to_today]).order(:fire => :desc, :deadline => :asc) - @today_tasks_over_deadline - @today_tasks_sorted
    @next_tasks = current_employee.active_tasks.where("finished = ? AND (deadline BETWEEN ? AND ? OR planning_state = ?)", false, Date.today.end_of_day, (Date.today + 7).end_of_day, Task.planning_states[:to_next]).order(:fire => :desc, :deadline => :asc)- @today_tasks_over_deadline - @today_tasks_sorted - @today_tasks_normal
    @other_tasks = current_employee.active_tasks.where(:finished => false).order(:fire => :desc, :deadline => :asc) - @today_tasks_over_deadline - @today_tasks_normal - @next_tasks - @today_tasks_sorted
  end

  def all_tasks
    @employees = Employee.where(:user_id => current_user.id).includes(:tasks, :group)
  end

  def in_control
    @employees = Employee.where(:user_id => current_user.id).includes(:tasks, :group)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    employee_id = find_employee_id
    @employee_task = EmployeeTask.where(task_id: @task.id, employee_id: employee_id).take
    @author = EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:author]).take.employee.user
    @sub_tasks = EmployeeTask.where(:parent_id => @employee_task.id)

    @employees = @task.employees
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        if params[:parent].present? && allowed_empl_task(params[:parent])
          EmployeeTask.create!(:employee_id => current_employee.id, :task_id => @task.id, :parent_id => params[:parent])
        else
          EmployeeTask.create!(:employee_id => current_employee.id, :task_id => @task.id)
        end
        if params[:employee_id].present? && params[:employee_id].to_i != current_employee.id
          @task.prepare_to_delegate(current_employee.id, params[:employee_id].to_i)
        end
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete
    @task.transaction do
      @task.update!(:finished => true, :finish_time => DateTime.now)
      my_empl_id = current_user.employee_ids & @task.employee_ids
      my_empl_task = EmployeeTask.where(task_id: @task.id, employee_id: my_empl_id).take
      if my_empl_task.author?
        performer = EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:performer])
        if performer.present?
          performer.take.update!(state: :completed)
        end
        my_empl_task.update!(state: :completed)
      else
        EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:author]).take.update!(state: :confirmation)
        my_empl_task.update!(state: :confirmation)
      end
      @task.employee_ids.each do |id|
        if id != my_empl_id
          Notification.create!(employee_id: id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> завершил задачу <a href=\"#{task_path(@task)}\">#{@task.title}</a>")
        end
      end
    end
    redirect_to back_or_default, notice: 'Задача завершена'
  end

  def restore
    @task.transaction do
      @task.update!(:finished => false, :finish_time => nil)
      my_emp_task = EmployeeTask.where(task_id: @task.id, employee_id: (current_user.employee_ids & @task.employee_ids)).take
      if my_emp_task.author?
        performer = EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:performer])
        if performer.present?
          my_emp_task.update!(state: :delegated)
          performer.take.update!(state: :active)
        else
          my_emp_task.update!(state: :active)
        end
      else
        EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:author]).take.update!(state: :delegated)
        my_emp_task.update!(state: :active)
      end
      @task.employee_ids.each do |id|
        if id != my_emp_task.id
          Notification.create!(employee_id: id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> восстановил задачу <a href=\"#{task_path(@task)}\">#{@task.title}</a>")
        end
      end
    end
    redirect_to back_or_default, notice: 'Задача восстановлена'
  end

  def edit_sort
    ids = params[:ids].split(',')
    new_sort_pressed = ids.index(params[:pressed_id])
    tasks_with_old_sort = Task.where("sort_value >= ?", new_sort_pressed)

    tasks_with_old_sort.update_all("sort_value = sort_value + 1")

    for i in 0...ids.count
      Task.find(ids[i]).update!(:sort_value => i)
    end

    render json: {status: 'success'}
  end

  def clear_sort
    Task.where.not(:sort_value => nil).update_all(:sort_value => nil)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json {}
    end
  end

  def delegate
    if params[:employee_id].blank?
      redirect_to_back_or_default notice: "Нужно выбрать кого-то"
      return
    end
    @task.prepare_to_delegate(current_employee.id, params[:employee_id].to_i)
    redirect_to root_path, notice: "Заявка отправлена"
  end

  def remove_access
    my_employee_task = EmployeeTask.where(employee_id: find_employee_id, task_id: @task.id).take
    if not my_employee_task.author?
      redirect_to back_or_default, notice: 'У вас нет прав'
      return
    end
    @task.transaction do
      employee_task = EmployeeTask.find(params[:employee_task_id])
      if my_employee_task.delegated?
        my_employee_task.update!(state: :active)
        Notification.create!(employee_id: employee_task.employee_id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> закрыл вам доступ к задаче \"#{@task.title}\"")
      elsif my_employee_task.confirmation?
        my_employee_task.update!(state: :completed)
        Notification.create!(employee_id: employee_task.employee_id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> закрыл вам доступ к задаче \"#{@task.title}\"")
      elsif my_employee_task.prepare_to_delegate?
        Proposal.where(task_id: @task.id, supplier_id: find_employee_id).take.destroy!
        my_employee_task.update!(state: :active)
        Notification.create!(employee_id: employee_task.employee_id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> отменил заявку на задачу \"#{@task.title}\"")
      end
      employee_task.destroy!
    end
    redirect_to @task, notice: 'Доступ пользователю закрыт'
  end

  def confirm_completion
    my_employee_task = EmployeeTask.where(employee_id: find_employee_id, task_id: @task.id).take
    if not my_employee_task.author?
      redirect_to back_or_default, notice: 'У вас нет прав'
      return
    end
    performer = EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:performer])
    @task.transaction do
      if performer.present?
        performer.take.update!(state: :completed)
        Notification.create!(employee_id: performer.take.id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> подтвердил завершение задачи <a href=\"#{task_path(@task)}\">#{@task.title}</a>")
      end
      my_employee_task.update!(state: :completed)
    end
    redirect_to @task, notice: 'Завершение подтверждено'
  end

  def refuse_completion
    my_emp_task = EmployeeTask.where(task_id: @task.id, employee_id: find_employee_id).take
    if not my_emp_task.author?
      redirect_to back_or_default, notice: 'У вас нет прав'
      return
    end
    @task.transaction do
      @task.update!(:finished => false, :finish_time => nil)
      performer = EmployeeTask.where(task_id: @task.id, role: EmployeeTask.roles[:performer])
      if performer.present?
        my_emp_task.update!(state: :delegated)
        performer.take.update!(state: :active)
      else
        my_emp_task.update!(state: :active)
      end
      @task.employee_ids.each do |id|
        if id != my_emp_task.id
          Notification.create!(employee_id: id, text: "<a href=\"#{user_path(current_user)}\">#{current_user.name}</a> не подтвердил завершение задачи <a href=\"#{task_path(@task)}\">#{@task.title}</a>")
        end
      end
    end
    redirect_to back_or_default, notice: 'Задача восстановлена'
  end

  private

  def allowed_user
    if (current_user.employee_ids & @task.employee_ids).empty?
      redirect_to tasks_url, notice: 'Недостаточно прав для просмотра'
    end
  end

  def allowed_empl_task(empl_task)
    empl_task = EmployeeTask.find(empl_task.to_i)
    if current_user.employee_ids.include?(empl_task.employee_id)
      true
    else
      false
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :description, :deadline, :fire, :planning_state)
  end

  def find_employee_id
    (current_user.employee_ids & @task.employee_ids).first
  end
end
