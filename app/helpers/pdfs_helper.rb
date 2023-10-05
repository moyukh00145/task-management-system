# frozen_string_literal: true

# PdfsHelper module
module PdfsHelper
  def format_task(pdf)
    pdf.text 'Task Details', size: 16, style: :bold, color: '256af5'
    pdf.font_size 14
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    task_name_category(pdf)
    task_assign(pdf)
    task_date(pdf)
    task_time(pdf)
    task_status(pdf)
  end

  def task_name_category(pdf)
    pdf.text_box 'Task Name: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color @sub_color
    pdf.text_box @task.task_name, at: [300, pdf.cursor]
    pdf.move_down 20
    pdf.fill_color @main_color
    pdf.text_box 'Category: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color @sub_color
    pdf.text_box @task.task_category.task_name, at: [300, pdf.cursor]
    pdf.move_down 20
  end

  def task_date(pdf)
    pdf.fill_color @main_color
    pdf.text_box 'Scheduled Date: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color @sub_color
    pdf.text_box @task.task_date.tomorrow? ? 'Tomorrow' : @task.task_date.strftime('%A, %B %d, %Y').to_s,
                 at: [300, pdf.cursor]
    pdf.move_down 20
  end

  def task_assign(pdf)
    pdf.fill_color @main_color
    pdf.text_box 'Assigned To: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color @sub_color
    pdf.text_box "#{@task.user.name}  #{@task.user.surname}", at: [300, pdf.cursor]
    pdf.move_down 20
  end

  def task_time(pdf)
    pdf.fill_color @main_color
    pdf.text_box 'Scheduled Time: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color @sub_color
    pdf.text_box @task.task_date.strftime('%H:%M %p'), at: [300, pdf.cursor]
    pdf.move_down 20
  end

  def task_status(pdf)
    pdf.fill_color @main_color
    pdf.text_box 'Current Status: ', at: [0, pdf.cursor], style: :bold
    pdf.fill_color '22f71b'
    pdf.text_box @task.status, at: [300, pdf.cursor]
    pdf.move_down 20
  end

  def create_approval_stamp(pdf)
    pdf.fill_color @main_color
    pdf.move_down 20
    pdf.create_stamp('approved') do
      stamp(pdf)
    end
    pdf.stamp_at 'approved', [500, 550]
    pdf.move_down 20
  end

  def stamp(pdf)
    pdf.rotate(30, origin: [-5, -5]) do
      pdf.stroke_color 'FF3333'
      pdf.stroke_ellipse [0, 0], 36, 15
      pdf.stroke_color '000000'
      pdf.fill_color '993333'
      pdf.font('Times-Roman') do
        pdf.draw_text 'Approved', at: [-25, -5]
      end
      pdf.fill_color '000000'
    end
  end

  def format_subtasks(pdf)
    pdf.font_size 12
    pdf.text 'Subtasks:', style: :bold
    pdf.move_down 20
    if @sub_tasks.count.positive?
      pdf.indent(20) do
        subtasks_available(pdf)
      end
    else
      pdf.text 'No subtasks available.'
    end
  end

  def subtasks_available(pdf)
    @sub_tasks.each do |subtask|
      pdf.fill_color @main_color
      pdf.text_box "#{subtask.name} : ", at: [0, pdf.cursor], style: :bold
      pdf.fill_color '22f71b'
      pdf.text_box subtask.status, at: [300, pdf.cursor]
      pdf.move_down 20
    end
  end
end
