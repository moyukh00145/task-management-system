# frozen_string_literal: true

# spec/models/user_spec.rb

require 'rails_helper'
# rubocop:disable Metrics
RSpec.describe User, type: :model do
  describe 'validations1' do
    it 'validates presence of name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of surname' do
      user = User.new(surname: nil)
      expect(user).not_to be_valid
      expect(user.errors[:surname]).to include("can't be blank")
    end

    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  describe 'validations2' do
    it 'validates uniqueness of email' do
      FactoryBot.create(:user, email: 'john@example.com', name: 'John', surname: 'doe', roles: 0)
      user = FactoryBot.build(:user, email: 'john@example.com', name: 'John', surname: 'doe', roles: 0)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'validates presence of roles' do
      user = User.new(roles: nil)
      expect(user).not_to be_valid
      expect(user.errors[:roles]).to include("can't be blank")
    end

    it 'validates the format of email' do
      user = User.new(email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'indexing' do
    it 'indexes data in Elasticsearch' do
      expect(User.__elasticsearch__).to receive(:create_index!)
      expect(User.__elasticsearch__).to receive(:import).with(force: true)
      User.index_data
    end
  end
end
# rubocop:enable Metrics
