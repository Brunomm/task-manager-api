class Api::V2::TasksController < ApplicationController
  before_action :authenticate_with_token!
  def index
    tasks = current_user.tasks
    render json: {tasks: tasks}
  end

  def show
    task = current_user.tasks.find(params[:id])
    render json: task
  end

  def create
    task = current_user.tasks.create( task_attributes )
    if task.persisted?
      render json: task, status: 201
    else
      render json: {errors: task.errors}, status: 422
    end
  end

  def update
    task = current_user.tasks.find(params[:id])
    if task.update(task_attributes)
      render json: task, status: 200
    else
      render json: {errors: task.errors}, status: 422
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    if task.destroy
      render status: 204
    else
      render json: {errors: task.errors}, status: 422
    end
  end

private

  def task_attributes
    params.require(:task).permit(:title, :description, :deadline, :done)
  end
end
