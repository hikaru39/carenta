class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  private 
   def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
   end
  helper_method :current_user
  
  class LoginRequired < StandardError; end
   
  rescue_from LoginRequired, with: :rescue_login_required
  
  def login_required
    raise LoginRequired unless current_user
  end
  
  def admin_login_required
    raise Forbidden unless current_user&.administrator_flag?
  end
    
  private
    def rescue_login_required(exception)
      render "errors/login_required", status: 403, layout: "error",format: [:html]
    end
end
