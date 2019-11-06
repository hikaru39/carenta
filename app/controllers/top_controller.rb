class TopController < ApplicationController
  def index
    @items = Item.search(params).page(params[:page]).per(20).order(created_at: :desc)
  end
end
