# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate, only: %i[index show upload_avatar]

  def index
    render json: users, adapter: :json
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
    if user.update(user_avatar)
      render json: { avatar_url: user.avatar_url }, status: :created
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end

  private

  def user
    @user = User.find(params[:id])
  end

  def users
    @users = User.all
  end

  def user_params
    params.require(:user).permit(:name, :password, :email, :first_name, :last_name)
  end

  def user_avatar
    params.permit(:id, :avatar)
  end
end
