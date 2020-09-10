class User < ApplicationRecord
  rolify

  after_create :assign_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :unit, optional: true
  has_many :job_applications, dependent: :destroy, foreign_key: "candidate_id",
           class_name: JobApplication.name
  has_one :profile, dependent: :destroy, autosave: true
  has_many :job_posts, dependent: :destroy
  has_many :notifications, class_name: Notification.name,
           foreign_key: :receiver_id, dependent: :destroy
  has_many :send_notifications, class_name: Notification.name,
           foreign_key: :sender_id, dependent: :destroy

  accepts_nested_attributes_for :profile

  delegate :full_name, :introduction, :phone_number, to: :profile, allow_nil: true
  delegate :id, to: :profile, prefix: true, allow_nil: true
  delegate :id, to: :unit, prefix: true, allow_nil: true

  def assign_default_role
    add_role :candidate if roles.blank?
  end
end
