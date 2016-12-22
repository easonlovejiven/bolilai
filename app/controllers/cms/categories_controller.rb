class Cms::CategoriesController <Cms::ApplicationController

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
    @template_type = @category.template_type
    case @template_type.to_s
      when 'list'
        @pages = @category.pages.active.published.order("position asc").order("created_at desc").page(params[:page]).per(5)
        @rmd_pages = @category.pages.tagged_with('推荐').active.published.limit(10)
      when 'default'
        if params[:page_id].blank?
          @page=@category.pages.active.published.first || Cms::Page.new
        else
          @page=Cms::Page.find(params[:page_id])
        end
        @category=@category.parent if !@category.parent.blank? && !@category.root?
      when 'show'
    end
    unless @category.published
      not_found_source!
      return
    end
    respond_to do |format|
      format.html { render @template_type }
      format.xml { render :xml => @category }
    end
  end

  protected
  def category_params
    params[:category].permit(["name", "description", "template_type", "url", "parent_id", "attribute_ids", "pic", "measures", "measure_properties"])
  end
end
