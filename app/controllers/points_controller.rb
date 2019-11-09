class PointsController < ApplicationController
  before_action :login_required
  before_action :set_user
  
  def index
    @points = Point.where(user_id: @user.id).latest
      .page(params[:page]).per(20)
  end
  
#  def histories
#    # @points = Point.order(processed_at: :desc)
#    @user_points = Point.group(:user_id)
#      .select("user_id, MAX(processed_at) AS max_processed_at")
#      .includes(:user)
#      .order(max_processed_at: :desc)
#      .map { |m| { name: m.user.name, max_processed_at: m.max_processed_at} }
#  end

  def show
    @point = Point.find(params[:id])
  end

  def new
    @latest_point = Point.where(user_id: @user.id).latest.first
    @point = Point.new(user_id: @user.id)
  end

  def create
    @latest_point_id = params[:latest_point_id].to_i
    @latest_point = Point.where(user_id: @user.id).latest.first
    if @latest_point_id != @latest_point.id
      return redirect_to ({:admin_action => 'new'}), alert: "想定されていないポイントが追加されたため、登録に失敗しました。"
    end
    @point = Point.new(point_params)
    @point.point = @latest_point.point + @point.difference
    @point.processed_at = Time.current
    if @point.save
      redirect_to ({:admin_action => 'index'}), notice: "ポイントを登録しました。"
    else
      render "new"
    end
  end
  
  private
    def point_params
      params.require(:point).permit(:user_id, :point, :difference, :category, :processed_at)
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end
end
