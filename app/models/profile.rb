class Profile < ApplicationRecord
  PROFILE_PARAMS = %i(first_name last_name introduction date_of_birth gender address phone_number file) \
    << {educations_attributes: %i(id college major date_from date_to certification additional_information _destroy)} \
    << {experiences_attributes: %i(id company_name job_position date_from date_to additional_information _destroy)}
  VALID_PHONE_NUMBER_REGEX = Settings.validations.profile.phone_number

  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_one_attached :file

  accepts_nested_attributes_for :educations, :experiences, allow_destroy: true, reject_if: :all_blank

  enum gender: {male: 1, female: 2, third_sex: 3}

  validate :correct_document_mime_type

  validates :first_name, :last_name, presence: true,
    length: {minimum: Settings.validations.profile.first_name.minimum,
             maximum: Settings.validations.profile.first_name.maximum}
  validates :address,
            length: {maximum: Settings.validations.profile.address.maximum}
  validates :introduction, allow_nil: true,
    length: {maximum: Settings.validations.profile.introduction.maximum}
  validates :phone_number, allow_nil: true,
    format: {with: VALID_PHONE_NUMBER_REGEX},
    uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def correct_document_mime_type
    return unless file.attached? && !file.content_type.in?(%w(application/msword application/pdf))

    errors.add(:file, "Must be a PDF or a DOC file")
  end
end
