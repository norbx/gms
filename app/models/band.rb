# frozen_string_literal: true

class Band < ApplicationRecord
  validates :name, presence: true
end
