# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  def index
    @tasks = Task.where(completed: false)
    @completed_tasks = Task.where(completed: true)
    Rails.logger.debug "Tasks: #{@tasks.inspect}"
    Rails.logger.debug "Completed Tasks: #{@completed_tasks.inspect}"
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.completed = false
    if @task.save
      Rails.logger.info "Task created: #{@task.inspect}"
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      Rails.logger.error "Task creation failed: #{@task.errors.full_messages.join(", ")}"
      redirect_to tasks_path, alert: 'Error creating task.'
    end
  end

  def update
    def update
      @task = Task.find(params[:id])
      if @task.update(task_params)
        render json: { status: 'success' }
      else
        render json: { status: 'error', errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end

  private

  def task_params
    params.require(:task).permit(:name, :completed)
  end
end
