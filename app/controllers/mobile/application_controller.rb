class Mobile::ApplicationController < ApplicationController
  # layout "mobile/application"
  theme "touch"
  private

  def authorized?
    @enable_lazyload = true

    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end

  def not_authorized
    if @current_user
      respond_to do |format|
        format.html { raise ActiveResource::ForbiddenAccess.new(response) }
        format.js { raise ActiveResource::ForbiddenAccess.new(response) }
        format.xml { raise ActiveResource::ForbiddenAccess.new(response) }
      end
    else
      respond_to do |format|
        format.html {
          # if request.url =~ /\.barlar\.cn/
          #   redirect_to '/'
          #   return
          # end
          redirect_to root_path(:redirect => request.fullpath)
        }
        format.js { raise ActiveResource::UnauthorizedAccess.new(response) }
        format.xml { raise ActiveResource::UnauthorizedAccess.new(response) }
        format.json { raise ActiveResource::UnauthorizedAccess.new(response) }
      end
    end
  end
end
