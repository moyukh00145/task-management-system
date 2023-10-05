# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics
RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'is invalid without a task_name' do
      task = FactoryBot.build(:task, task_name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_name]).to include("can't be blank")
    end

    it 'is invalid without a task_category' do
      task = FactoryBot.build(:task, task_category: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_category]).to include("can't be blank")
    end

    it 'is invalid without a task_date' do
      task = FactoryBot.build(:task, task_date: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_date]).to include("can't be blank")
    end

    it 'is invalid without a task_time' do
      task = FactoryBot.build(:task, task_time: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_time]).to include("can't be blank")
    end

    it 'is invalid without a repeat_interval' do
      task = FactoryBot.build(:task, repeat_interval: nil)
      expect(task).not_to be_valid
      expect(task.errors[:repeat_interval]).to include("can't be blank")
    end

    it 'is invalid without a task_importance' do
      task = FactoryBot.build(:task, task_importance: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_importance]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      task = FactoryBot.build(:task, description: nil)
      expect(task).not_to be_valid
      expect(task.errors[:description]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a task_category' do
      association = described_class.reflect_on_association(:task_category)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many sub_tasks' do
      association = described_class.reflect_on_association(:sub_tasks)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'factory' do
    it 'is valid' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'creates a task with sub_tasks' do
      task = FactoryBot.create(:task, :with_sub_tasks)
      expect(task.sub_tasks.count).to eq(3)
    end
  end
end
# rubocop:enable Metrics
