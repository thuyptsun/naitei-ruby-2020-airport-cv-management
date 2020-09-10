class Notification < ApplicationRecord
  after_create :send_notification

  enum message: {reviewing: 0, cancelled: 1}

  belongs_to :job_application
  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :desc_order, ->{order created_at: :desc}

  def send_notification
    NotificationBroadcastJob.perform_now self
  end
end
