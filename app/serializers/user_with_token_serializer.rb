# frozen_string_literal: true

class UserWithTokenSerializer < ActiveModel::Serializer
  attribute :token
  attribute :user do
    {
      id: object.id,
      email: object.email,
      name: object.name,
      first_name: object.first_name,
      last_name: object.last_name
    }
  end
end
