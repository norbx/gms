# frozen_string_literal: true

class Band < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags

  scope :active, -> { where(active: true) }

  def tags_attributes=(tags_array)
    self.tags = tags_array.map { Tag.find_or_initialize_by(_1) }
  end
end
