class JobApplication < ApplicationRecord
  after_save :create_notification

  belongs_to :job_post
  belongs_to :candidate, class_name: User.name
  belongs_to :recruiter, class_name: User.name, optional: true

  delegate :title, to: :job_post, prefix: true, allow_nil: true
  delegate :category_title, to: :job_post, prefix: true, allow_nil: true
  delegate :location, to: :job_post, prefix: true, allow_nil: true
  delegate :phone_number, to: :candidate, prefix: true, allow_nil: true
  delegate :id, to: :job_post, prefix: true, allow_nil: true

  enum status: {reviewing: "reviewing",
                interviewing: "interviewing",
                accepted: "accepted",
                denied: "denied",
                cancelled: "cancelled"}

  scope :desc_order, ->{order created_at: :desc}
  scope :find_job_appl, ->(id){where(job_post_id: id)}

  def create_notification
    return unless reviewing? || cancelled?

    notification = Notification.new
    notification.job_application = self
    notification.sender = candidate
    notification.receiver = job_post.user
    notification.reviewing! if reviewing?
    notification.cancelled! if cancelled?
  end
end
