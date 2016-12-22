class Shop::ApplicationController < ApplicationController
  # layout 'purple/application'
  theme "purple"
  private

  def current_app
    @current_app ||= AUCTION_APP
  end

  def authorized?
    @enable_lazyload = true

    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
