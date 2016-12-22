class Mobile::Cms::PagesController < Mobile::ApplicationController
  def show
    @page = ::Cms::Page.acquire(params[:id])
    unless @page.published
      not_authorized
      return
    end
  end
  def authorized?
    return true
  end
end
