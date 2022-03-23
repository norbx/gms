# frozen_string_literal: true

class BandSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :phone_number
  attribute :contact_name
  attribute :description
  attribute :social_links
  attribute :active
end
