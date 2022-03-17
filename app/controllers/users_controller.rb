# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate, except: :create

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
end
