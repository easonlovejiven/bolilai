class Cms::PagesController < Cms::ApplicationController
  def show
    @page = ::Cms::Page.acquire(params[:id])
    @template_type = @page.template_type.to_s
    @rmd_pages = @page.category.pages.active.published.limit(10)
    unless @page.published
      not_found_source!
      return
    end
  end
end
