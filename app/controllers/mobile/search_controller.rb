class Mobile::SearchController < Mobile::ApplicationController
  def index
  end

  def authorized?
    @enable_lazyload = true
    return true if %w[index].include?(params[:action])
    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
