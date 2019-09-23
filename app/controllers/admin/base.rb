class Admin::Base < ApplicationController
  before_action :admin_login_required
end