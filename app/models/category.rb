class Category < ApplicationRecord
  has_many :job_posts, dependent: :destroy

  scope :home_popular_category, ->{limit Settings.category.home}

  validates :title, presence: true, uniqueness: true
end
