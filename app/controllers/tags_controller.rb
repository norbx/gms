# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :authenticate, only: %i[show]

  def index
    render json: Tag.all, adapter: :json, root: 'tags'
  end

  def show
    render json: Tag.find(params[:id]), adapter: :json, root: 'tag'
  end
end
