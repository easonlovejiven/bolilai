class Mobile::HelpsController < Mobile::ApplicationController
  def index
    @category = ::Cms::Category.find_by_url("help")
    @pages = @category.pages.active.page(params[:page]).per(5)
  end

  def show
    @page = ::Cms::Page.acquire(params[:id])
  end

end
