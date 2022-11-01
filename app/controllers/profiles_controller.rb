# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate, only: %i[index update]

  def index
    render json: current_user, adatper: :json, root: 'user'
  end
end
