# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubTask, type: :model do
  describe 'associations' do
    it 'belongs to a task' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'factory' do
    it 'is valid' do
      sub_task = FactoryBot.build(:sub_task)
      expect(sub_task).to be_valid
    end
  end
end
