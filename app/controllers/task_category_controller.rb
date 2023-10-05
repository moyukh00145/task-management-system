# frozen_string_literal: true

# TaskCategoryController class
class TaskCategoryController < ApplicationController
  def create
    @task_category = TaskCategory.create(task_name: params[:data])
    respond_to(&:js)
  end

  def update
    category = TaskCategory.update_category(params)
    render json: { status: category.present? }
  end

  def destroy
    TaskCategory.find(params[:id]).destroy
    respond_to(&:js)
  end
end
