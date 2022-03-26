# frozen_string_literal: true

class Tag < ApplicationRecord
  before_validation { name.capitalize! }
  validates :name, presence: true, uniqueness: true,
                   format: { with: /\A[a-zA-Z]+-? ?[a-z]+-? ?[a-z]+5\z/,
                             message: 'only allows letters and single dashes' }

  has_and_belongs_to_many :bands
end
