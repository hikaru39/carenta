class ItemImagesController < ApplicationController
  before_action do
    # @item = current_user.items.find(params[:item_id])
    @item = Item.find(params[:item_id])
  end
  
  def index
    @images = @item.images.order(:position)
  end
  
  def show
    redirect_to action: "edit"
  end

  def new
    @image = @item.images.build
  end

  def edit
    @image = @item.images.find(params[:id])
  end
  
  def create
    @image = @item.images.build(image_params)
    if @image.save
      redirect_to [@item, :images], notice: "画像を作成しました。"
    else
      render "new"
    end
  end
  
  def update
    @image = @item.images.find(params[:id])
    @image.assign_attributes(image_params)
    if @image.save
      redirect_to [@item, :images], notice: "画像を更新しました。"
    else
      render "edit"
    end
  end
  
  def destroy
    @image = @item.images.find(params[:id])
    @image.destroy
    redirect_to [@item, :images], notice: "画像を削除しました。"
  end
  
  def move_higher
    @image = @item.images.find(params[:id])
    @image.move_higher
    redirect_back fallback_location: [@item, :images]
  end
  
  def move_lower
    @image = @item.images.find(params[:id])
    @image.move_lower
    redirect_back fallback_location: [@item, :images]
  end
  
  private
    def image_params
      params.require(:image).permit(:new_data)
    end
end
