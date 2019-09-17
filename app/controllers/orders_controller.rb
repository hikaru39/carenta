class OrdersController < ApplicationController
  before_action :login_required
  
  def index
    if params[:user_id]
      @user = User.order(update_at: :desc)
      @orders = @user.orders
    else
      @orders = Order.all
    end
      .page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end
  
  def create
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to @order, notice: "注文の作成が完了しました。"
    else
      render "new"
    end
  end
  
  def update
    @order = Order.find(params[:id])
    @order.assign_attributes(order_params)
    if @order.save
      redirect_to @order, notice: "注文を更新しました。"
    else
      render "edit"
    end
  end
  
  private
    def order_params
      params.require(:order).permit(:item_id, :user_id, :type, :status, :rental_point, :point)
    end
end
