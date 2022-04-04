# frozen_string_literal: true

class BandSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :phone_number
  attribute :contact_name
  attribute :description
  attribute :social_links
  attribute :active
  attribute :images do
    object.images.map do |image|
      {
        id: image.id,
        url: image.url
      }
    end
  end

  has_many :tags
end
