# frozen_string_literal: true

class Band < ApplicationRecord
  include PgSearch::Model

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags
  has_many_attached :images

  pg_search_scope :band_search,
                  against: %i[name description],
                  associated_against: { tags: [:name] },
                  using: { tsearch: { prefix: true } }

  validates :name, presence: true
  validates :images, if: :images,
                     content_type: %i[image/png image/jpg image/jpeg image/webp],
                     limit: { max: 5 },
                     size: { less_than: 10.megabytes, message: 'file size should be lesser than 10mb' }

  accepts_nested_attributes_for :tags

  scope :active, -> { where(active: true) }

  def tags_attributes=(tags_array)
    self.tags = tags_array.map { Tag.find_or_initialize_by(_1) }
  end
end
