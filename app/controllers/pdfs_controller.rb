# frozen_string_literal: true

# PdfsController class
class PdfsController < ApplicationController
  include PdfsHelper
  before_action :check_session
  def generate_pdf
    @task = Task.find(params[:id])
    @sub_tasks = @task.sub_tasks
    @sub_color = '861bf7'
    @main_color = '000000'
    pdf = Prawn::Document.new
    format_task(pdf)
    create_approval_stamp(pdf)
    format_subtasks(pdf)
    send_data pdf.render, filename: "task_#{@task.id}_#{(Time.now.to_f * 1000).to_i}", type: 'application/pdf',
                          disposition: 'attachment'
  end
end
