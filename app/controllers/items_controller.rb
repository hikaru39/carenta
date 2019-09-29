class ItemsController < ApplicationController
  before_action :login_required, except: [:index, :show]
  
  def index
    @items = Item.search(params)
    
    @items = @items.page(params[:page]).per(20)
  end
  
  def show
    @item = Item.find(params[:id])
    @comments = @item.comments
    @comment = Comment.new
  end
  
  def new
    @item = Item.new
    @item.user = current_user
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def create
    @item = Item.new(item_params)
    @item.user = current_user
    if @item.save
      redirect_to @item, notice: "商品を登録しました。"
    else
      render "new"
    end
  end
  
  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)
    if @item.save
      redirect_to @item, notice: "商品を更新しました。"
    else
      render "edit"
    end
  end
  
  def like
    @item = Item.find(params[:id])
    current_user.favorited_items << @item
    redirect_to @item, notice: "お気に入りに追加しました。"
  end
  
  def unlike
    current_user.favorited_items.destroy(Item.find(params[:id]))
    redirect_to :favorited_items, notice: "お気に入りから削除しました。"
  end
  
  private
    def item_params
      params.require(:item).permit(:name, :user_id, :point, :rental_point, :category, :condition, :description, :delivery_method, :status, :content)
    end
end
