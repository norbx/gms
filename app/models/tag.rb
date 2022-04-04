# frozen_string_literal: true

class Tag < ApplicationRecord
  before_validation { name.capitalize! }
  validates :name, presence: true, uniqueness: true,
                   format: { with: /\A[0-9a-zA-Z]+-? ?[0-9a-z]+-? ?[0-9a-z]+\z/,
                             message: 'only allows letters, numbers, single dashes and spaces' }

  has_and_belongs_to_many :bands
end
