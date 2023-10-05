# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskCategory, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task_category = FactoryBot.build(:task_category)
      expect(task_category).to be_valid
    end

    it 'is invalid without a task_name' do
      task_category = FactoryBot.build(:task_category, task_name: nil)
      expect(task_category).not_to be_valid
      expect(task_category.errors[:task_name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
    end
  end
end
