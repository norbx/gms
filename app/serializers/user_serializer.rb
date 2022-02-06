# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :email
  attribute :username
  attribute :first_name
  attribute :last_name
end
