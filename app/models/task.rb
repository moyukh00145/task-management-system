# frozen_string_literal: true

# Task Model
class Task < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  enum task_importance: {
    Low: 0,
    Medium: 1,
    High: 2
  }

  has_many :sub_tasks, dependent: :destroy
  has_many_attached :attachments

  belongs_to :user, optional: true
  belongs_to :task_category, foreign_key: 'task_category_id'

  after_create :create_uid

  validates :task_name, presence: true
  validates :task_category, presence: true
  validates :task_date, presence: true
  validates :task_time, presence: true
  validates :repeat_interval, presence: true
  validates :task_importance, presence: true
  validates :description, presence: true

  default_scope { order('DATE(task_date) ASC').order(task_importance: :desc) }
  scope :update_task_params, ->(id, update_params) { where(id:).update(update_params) }
  scope :find_authorized_task, lambda { |id, user_id|
                                 joins(:user).where(id:)
                                             .and(Task.where(assign_by: user_id)
                                             .or(Task.where(users: { employee_id: user_id })))
                               }
  scope :all_assigned_tasks, lambda { |employee_id, page_no|
                               where(assign_by: employee_id).order(:task_approval)
                                                            .page(page_no)
                                                            .per(10)
                             }
  scope :filter_user, ->(id) { where(user_id: id) }
  scope :filter_day, ->(day) { where('DATE(task_date) = ?', day) unless day.nil? }
  scope :filter_priority, ->(priority) { where(task_importance: priority) if priority != 3 }
  scope :filter_status, ->(status) { where(status: Task.statuses[status.titleize]) }
  scope :approaved_tasks, -> { where(task_approval: true).where(sended_to_hr: false) }
  scope :snded_to_hr, -> { where(sended_to_hr: true) }

  def self.index_data
    __elasticsearch__.create_index!
    __elasticsearch__.import force: true
  end

  settings do
    mappings dynamic: false do
      indexes :task_name, type: :text, analyzer: :english
      indexes :description, type: :text, analyzer: :english
      indexes :status, type: :integer
      indexes :user_id, type: :integer
      indexes :uid, type: :text
    end
  end

  def as_indexed_json(_options = {})
    {
      task_name:,
      description:,
      status: Task.statuses[status],
      user_id:,
      uid:
    }
  end

  def self.search_tasks(query, status, id)
    wildcards_query = query.split.map { |term| "*#{term}*" }.join(' ')
    response = search({ query: {
                        bool: {
                          must: [{ query_string: { query: wildcards_query, fields: %w[task_name description uid] } },
                                 { match: { user_id: id } }],
                          filter: { terms: { status: [status] } }
                        }
                      } })
    response.records
  end

  index_data

  def interval_of_notifications
    @interval_of_notification = {
      1 => 1.days,
      2 => 7.days,
      3 => 1.months,
      4 => 3.months,
      5 => 6.months,
      6 => 1.years
    }
  end

  def create_uid
    user_id = user.id
    self.uid = format('Task_%<timestamp>d%<user_id>03d%<id>03d', timestamp: Time.now.to_i, user_id:, id:)
    save
  end
end
