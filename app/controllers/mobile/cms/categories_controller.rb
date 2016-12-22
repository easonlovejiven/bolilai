class Mobile::Cms::CategoriesController < Mobile::ApplicationController

  def show
    if params[:path].blank?
      if !params[:cate_name].blank?
        id=params[:cate_name].to_s.match(/\d+$/).to_s
        @category = ::Cms::Category.find(id)
      else
        @category = ::Cms::Category.find(params[:id])
      end
    else
      @category = ::Cms::Category.find_by!(:url => "/#{params[:path]}")
    end
    unless @category.published
      not_authorized
      return
    end
    respond_to do |format|
      format.html {}
      format.xml { render :xml => @category }
    end
  end

  def authorized?
    return true
  end
end
