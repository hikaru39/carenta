class UsersController < ApplicationController
  before_action :login_required, expect: [:index, :destroy]
  before_action :admin_login_required, only: [:index, :destroy]
  skip_before_action :login_required, if: proc{action_name=="new" || action_name=="create" || action_name=="login_form"}
  
  def index
    @users = User.search(params[:q])
      .page(params[:page]).per(20)
  end
    
  def show
    @user = User.find(params[:id])
  end
    
  def new
    @user = User.new
  end
    
  def edit
    @user = User.find(params[:id])
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id unless current_user
      redirect_to @user, notice: "会員を登録しました。"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to @user, notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end
    
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :users, notice: "会員を削除しました。"
  end
  
  def favorited
    @user = User.find(params[:id])
    @items = @user.favorited_items
      .order("favorites.created_at DESC")
      .page(params[:page]).per(20)
  end
  
  def login_form
  end

private
  def user_params
    attrs = [:id, :new_profile_picture, :remove_profile_picture, :name, :email, :first_name, :last_name, :postal_code, :prefecture_id, :address1, :address2, :description, :administrator_flag]
    
    attrs << :password if params[:action] == "create"
    
    params.require(:user).permit(attrs)
  end
end
