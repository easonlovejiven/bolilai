class Home::ApplicationController < ApplicationController #:nodoc: all
  # layout 'purple/application'
  theme "purple"
  private

  def current_app
    @current_app ||= HOME_APP
  end

  # def authorized?
  # 	@enable_lazyload = true
  #
  # 	!!@current_user
  # end
  #
  def authorized?
    @enable_lazyload = true

    # @current_user = Core::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
