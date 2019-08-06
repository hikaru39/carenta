class AccountsController < ApplicationController
  before_action :login_required
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.assign_attributes(account_params)
    if @user.save
      redirect_to :account, notice: "アカウント情報を更新しました。"
    else
      render "edit"
    end
  end
  
  private 
    def account_params
      params.require(:account).permit(:id, :new_profile_picture, :remove_profile_picture, :name, :email, :first_name, :last_name, :postal_code, :prefecture_id, :address1, :address2, :description, :administrator_flag)
    end
end
