class ConsumersController < ApplicationController
  before_action :login_required
  before_action :set_order, only: [:show, :edit, :update]
  
  def index
    @orders = Order.where(user_id: current_user.id).order(updated_at: :desc)
  end
  
  def show
    redirect_to action: "edit"
  end
  
  def new
    @order = Order.new
    @order.user_id = current_user.id
    @order.item_id = params[:item_id]
  end
  
  def create
    @order = Order.new
    @order.user_id = current_user.id
    @order.item_id = params[:item_id]
    @order.status = :ordered
    @order.rental_point = @order.item.rental_point
    @order.point = @order.item.point
    @order.ordered_at = DateTime.now
    
    if (@order.user.latest_point - @order.item.rental_point) < 0
      flash.now[:alert] = "ポイントが不足しています。"
      return render "new"
    end
    
    ActiveRecord::Base.transaction do
      @order.save!
      
      @order.user.points.create!({
        difference: -1 * @order.item.rental_point,
        point: @order.user.latest_point - @order.item.rental_point,
        category: "rental: order_id=#{@order.id}",
        processed_at: DateTime.now
      })
      
      @order.item.user.points.create!({
        difference: @order.item.rental_point,
        point: @order.user.latest_point + @order.item.rental_point,
        category: "rental: order_id=#{@order.id}",
        processed_at: DateTime.now
      })
      
      redirect_to edit_consumer_path(id: @order.id), notice: "注文を完了しました。"
    end
    
  rescue
    flash.now[:alert] = "注文に失敗しました。"
    render "new"
  end
  
  def edit
  end
  
  def update
    ActiveRecord::Base.transaction do
      message = ''
      @order.status = params[:status]
      if @order.status.received?
        if @order.status_was.delivered?
          message = 'ありがとうございます。では商品の試用期間を開始させていただきます。'
          @order.received_at = DateTime.now
        else
          @order.errors.add(:status, "試用期間の開始に失敗しました。運営に連絡をお願いします。")
        end
      elsif @order.status.returned?
        if @order.status_was.received? 
          message = '商品の発送手続きありがとうございます。商品提供者の受領をもって完了とさせていただきます。'
          @order.returned_at = DateTime.now
        else
          @order.errors.add(:status, "商品発送状態への変更に失敗しました。運営に連絡をお願いします。")
        end
      elsif @order.status.finished?
        if @order.status_was.received? 

          if (@order.user.latest_point - (@order.item.point - @order.item.rental_point)) < 0
            flash.now[:alert] = "ポイントが不足しています。"
            return render "new"
          end
      
          @order.user.points.create!({
            difference: -1 * (@order.item.point - @order.item.rental_point),
            point: @order.user.latest_point - (@order.item.point - @order.item.rental_point),
            category: "buy: order_id=#{@order.id}",
            processed_at: DateTime.now
          })
          
          @order.item.user.points.create!({
            difference: (@order.item.point - @order.item.rental_point),
            point: @order.user.latest_point + (@order.item.point - @order.item.rental_point),
            category: "buy: order_id=#{@order.id}",
            processed_at: DateTime.now
          })
          
          if @order.type == :buy
            message = '商品購入手続きが完了しました。ご利用ありがとうございました。'
            @order.finished_at = DateTime.now
          end
        else
          @order.errors.add(:status, "購入完了状態への変更に失敗しました。運営に連絡をお願いします。")
        end
      end
        
      if @order.errors.empty? && @order.save
        redirect_to edit_consumer_path(id: @order.id), notice: message
      else
        render "new"
      end
    end
    
  rescue
    if @order.status.finished?
      flash.now[:alert] = "購入に失敗しました。"
    else
      flash.now[:alert] = "状態の変更に失敗しました。"
    end
    render "new"
  end
  
  private
    def set_order
      @order = Order.find_by(id: params[:id])
    end
end
