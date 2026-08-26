class Task < ApplicationRecord
  enum :priority, { "低": 0, "中": 1, "高": 2 }
  enum :status, { "未着手": 0, "着手中": 1, "完了": 2 }

  scope :recent, -> { order(created_at: :desc) }
  scope :sort_deadline_on, -> { order(deadline_on: :asc) }
  scope :sort_priority, -> { order(priority: :desc) }
  scope :search_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :search_status, ->(status) { where(status: status) }  

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end