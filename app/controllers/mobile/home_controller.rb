class Mobile::HomeController < Mobile::ApplicationController
  def index
  end

  def set_cookies
    user_cookies
    respond_to do |format|
      @data= @current_user.blank? ? {} : {user_id: @current_user.id}
      format.xml { @data }
    end
  end

  def user_center

  end

  def loading

  end


  def authorized?
    @enable_lazyload = true
    return true if %w[index loading set_cookies].include?(params[:action])
    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end


end
