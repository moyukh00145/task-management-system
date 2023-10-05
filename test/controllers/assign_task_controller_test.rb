# frozen_string_literal: true

require 'test_helper'

class AssignTaskControllerTest < ActionDispatch::IntegrationTest
  test 'should get addTask' do
    get assign_task_addTask_url
    assert_response :success
  end
end
