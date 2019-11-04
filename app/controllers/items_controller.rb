class ItemsController < ApplicationController
  before_action :login_required, except: [:index, :show]
  
  def index
    @search_params = {}
    @search_params[:q] = params[:q] if params[:q].present?
    @search_params[:user_id] = params[:user_id] if params[:user_id].present?
    @search_params[:parent_id] = params[:parent_id] if params[:parent_id].present?
    @search_params[:child_id] = params[:child_id] if params[:child_id].present?
    @search_params[:category_id] = params[:category_id] if params[:category_id].present?
    @search_params[:option] = params[:option] if params[:option].present?
    
    @items = Item.search(params).page(params[:page]).per(20)
  end
  
  def category_index
    @parents = Category.where(ancestry: nil).order("id ASC")
  end

  def show
    @item = Item.find(params[:id])
    @comments = @item.comments
    @comment = Comment.new
  end
  
  def new
    @item = Item.new
    @item.user = current_user
    get_top_categories
  end
  
  def get_top_categories
    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << [parent.name, parent.id]
    end
  end
  
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.get_children("#{params[:parent_id]}")
  end
  
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.get_grandchildren("#{params[:child_id]}")
  end
  
  def edit
    @item = Item.find(params[:id])
    get_top_categories
  end
  
  def create
    @item = Item.new(item_params)
    @item.user = current_user
    if @item.save
      redirect_to @item, notice: "商品を登録しました。"
    else
      get_top_categories
      render "new"
    end
  end
  
  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)
    if @item.save
      redirect_to @item, notice: "商品を更新しました。"
    else
      get_top_categories
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
      params.require(:item).permit(:name, :user_id, :point, :rental_point, :category_id, :condition, :description, :delivery_method, :status, :content)
    end
end
