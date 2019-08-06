class ItemsController < ApplicationController
  def index
    @items = Item.search(params[:q])
  end
  
  def show
    @item = Item.find(params[:id])
  end
  
  def new
    @item = Item.new
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def create
    @item = Item.new(item_params)
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
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to :items
  end
  
  private
    def item_params
      params.require(:item).permit(:name, :user_id, :point, :rental_point, :category, :condition, :description, :delivery_method, :states)
    end
end
