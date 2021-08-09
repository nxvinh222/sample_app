class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  delegate :name, to: :user, prefix: true

  PERMITTED_FIELDS = %i(content image).freeze

  validates :user_id, presence: true
  validates :content, presence: true, length:
    {maximum: Settings.micropost_max_size}
  validates :image, content_type: {in: Settings.image_restricted_types,
                                   message: :invalid_format_image},
            size: {less_than: Settings.max_image_size.megabytes,
                   message: :should_smaller}

  scope :newest, ->{order created_at: :desc}

  def display_image
    image.variant resize_to_limit: Settings.image_size_limit
  end
end
