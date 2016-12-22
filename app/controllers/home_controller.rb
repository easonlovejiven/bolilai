class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :platform, :cooperation]
  theme "purple"
  def index
    if @current_user
      redirect_to User::ROLES_HOME[@current_user.role]
    else
      render 'index'
    end
  end

  def cooperation
    render :text => "========= #{request.domain} ========"
  end

  def serviceinfo
    render :serviceinfo, layout: 'normal'
  end

  def platform
    render 'platform', layout: 'normal'
  end

  def features
    render :file => "#{Rails.root}/public/features.html"
  end

  def change_user
    sign_in :user, User.where(role: params[:role]).first
    redirect_to User::ROLES_HOME[params[:role]]
  end

  def set_layout_by_mobile
    if mobile_device?
      "mobile"
    else
      "application"
    end
  end
end
