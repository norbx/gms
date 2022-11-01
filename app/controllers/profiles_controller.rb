# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate, only: %i[index update]

  def index
    render json: current_user, adatper: :json, root: 'user', status: :ok
  end

  def update
    if current_user.update(user_params)
        render json: current_user, adapter: :json, root: 'user', status: :ok
    else
        render json: current_user.errors.full_messages, root: 'user', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name)
  end
end
