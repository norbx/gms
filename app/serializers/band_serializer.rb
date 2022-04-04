# frozen_string_literal: true

class BandSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :phone_number
  attribute :contact_name
  attribute :description
  attribute :social_links
  attribute :active
  attribute :image_urls do
    object.images.respond_to?(:url) ? object.images.map(&:url) : []
  end

  has_many :tags
end
