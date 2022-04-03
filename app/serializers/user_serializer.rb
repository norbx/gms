# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :email
  attribute :name
  attribute :first_name
  attribute :last_name
  attribute :is_musician
  attribute :avatar_url do
    object.avatar? ? object.avatar.url : nil
  end
end
