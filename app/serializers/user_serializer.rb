# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :email
  attribute :name
  attribute :first_name
  attribute :last_name
  attribute :is_musician
end
