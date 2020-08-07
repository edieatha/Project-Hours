class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def new
    @task = Task.new
  end

  def index
    @tasks = current_user.tasks
  end

  def index_tasks_no_project
    @tasks_no_project = current_user.tasks.includes(:project_tasks).where(project_tasks: { project_id: nil })
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.projects = Project.find(params[:task][:project_ids]) if params[:task][:project_ids]

    if @task.save
      if params[:task][:project_ids]
        redirect_to tasks_path, notice: 'Created task with project.'
      else
        redirect_to tasks_no_project_path, notice: 'Created task without project.'
      end
    else
      render :new, danger: 'Task creation failed.'
    end
  end

  def show; end

  def edit; end

  def update
    @task.projects = []
    @task.projects = Project.find(params[:task][:project_ids]) if params[:task][:project_ids]

    if @task.update(task_params)
      if params[:task][:project_ids]
        redirect_to tasks_path, notice: 'task updated!'
      else
        redirect_to tasks_no_project_path, notice: 'Task updated!'
      end
    else
      render :edit, danger: 'Task update failed.'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task deleted'
  end

  # def search
  #   @parameter = params[:search]
  #   @results = task.where('name LIKE ?', "%#{@parameter}%")
  # end

  private

  def set_task
    @task = task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :hours, :user_id, :project_id)
  end
end
