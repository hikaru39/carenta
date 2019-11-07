class ProvidersController < ApplicationController
  before_action :login_required
  before_action :set_order, only: [:show, :edit, :update]
  
  def index
    @orders = Order.joins(:item).merge(Item.where(user_id: current_user.id)).order(updated_at: :desc)
    @items = Item.where(user_id: current_user.id).order(updated_at: :desc)
  end
  
  def show
    redirect_to action: "edit"
  end
  
  def edit
  end
  
  def update
    message = ''
    @order.status = params[:status]
    if @order.status.delivered?
      if @order.status_was.ordered?
        message = '商品の発送手続きありがとうございます。購入者の受領をもって試用の開始とさせていただきます。'
        @order.delivered_at = DateTime.now
      else
        @order.errors.add(:status, "発送状態の変更に失敗しました。運営に連絡をお願いします。")
      end
    elsif @order.status.finished?
      if @order.status_was.returned? 
        message = '受領の確認ありがとうございます。この受注に関する手続きは完了とさせていただきます。'
        @order.returned_at = DateTime.now
      else
        @order.errors.add(:status, "受領確認状態への変更に失敗しました。運営に連絡をお願いします。")
      end
    end
      
    if @order.errors.empty? && @order.save
      redirect_to edit_provider_path(id: @order.id), notice: message
    else
      render "new"
    end
  end
  
  private
    def set_order
      @order = Order.find_by(id: params[:id])
    end
end
