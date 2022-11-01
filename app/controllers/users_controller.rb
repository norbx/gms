# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate, only: %i[index show upload_avatar]

  def index
    render json: User.all, adapter: :json
  end

  def show
    render json: user, adapter: :json
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created, serializer: UserWithTokenSerializer, adapter: :attributes
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def upload_avatar
    if current_user.avatar.attach(user_avatar['avatar'])
      render json: current_user, adapter: :json, status: :created, root: 'user'
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :email, :first_name, :last_name)
  end

  def user_avatar
    params.require(:user).permit(:avatar)
  end
end
